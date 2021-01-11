//
//  Network.swift
//  TaskTracker
//
//  Created by Harsha on 06/01/21.
//

import Foundation

/// Define the parameter's dictionary
public typealias ParametersDict = [String : Any]

public typealias JSON = [String: AnyObject]
/// Define the header's dictionary
public typealias HeadersDict = [String: String]

public enum Method: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

public enum DataType {
    case json, path
}

class SessionSingleton {
    
    static let shared = SessionSingleton()
    var network : Network?
    var session: URLSession?

    func requestForSession() -> URLSession {
        if let _session = session {
            return _session
        } else {
            session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)//URLSession(configuration: URLSessionConfiguration.default,delegateQueue: nil)
            return session ?? URLSession.init(configuration: URLSessionConfiguration.default)
        }
    }
    
    func requestForNetwork() -> Network {
        if let _network = network {
            return _network
        }else {
            network = Network()
            return network ?? Network()
        }
    }
    
    func removeSession() {
        session = nil
    }
}

class Network: NSObject {
    
    typealias CompletionHandler = (_ result: Data?, _ response: URLResponse?, _ error: Error?)-> Void
    var task: URLSessionDataTask?
    
    func request<T: RequestProtocol>(req: T, completionHandler: @escaping CompletionHandler) {
        let session = SessionSingleton.shared.requestForSession()
        
        var tempURL = URL(string: req.baseUrl.absoluteString + req.endpoint)
        
        if req.endpoint.hasPrefix("/") == false{
            tempURL = URL(string: req.baseUrl.absoluteString + "/" + req.endpoint)
        } else if req.endpoint.starts(with: "/") && req.endpoint.count > 1 {
            tempURL = URL(string: req.baseUrl.absoluteString + req.endpoint )
        }
        
        guard let tempUrl = tempURL else {return}
        let request = prepareRequest(for: tempUrl, req: req)
        
        task = session.dataTask(with: request) {(data, response, error) in
            NetworkLogger.log(response: data, response: response, error: error)
            
            DispatchQueue.main.async {
                completionHandler(data, response, error)
            }
        }
        task?.resume()
    }
    
    func cancelTask() {
        task?.cancel()
    }
}

extension Network {
    
    private func handleError(data: Data) ->String {
        let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
        // Response can come in array and dictionary format so need to handle both
        
        var json: [String : AnyObject]!
        if jsonResponse is Dictionary<String, AnyObject> {
            json = jsonResponse as? [String : AnyObject]
        }else {
            let responseArray =  jsonResponse as? [AnyObject]
            json = (responseArray?.count != 0) ? responseArray?[0] as? [String : AnyObject] : nil
        }
        
        let errorMessageArray = json["errors"] as? [JSON]
        let errorMessageDict = errorMessageArray?[0]
        let errorMessageString = errorMessageDict?["message"] as! String
        Logger("error message: \(errorMessageString)")
        return errorMessageString
    }
    
    private func prepareRequest<T: RequestProtocol>(for url: URL, req: T) -> URLRequest {
        
        var request : URLRequest? = nil
        
        switch req.query {
        case .json:
            var query = ""
            
            req.body?.forEach { (arg) in
                let (key, value) = arg
                query = query + "\(key)=\(String(describing: value))&"
            }
            
            if query.count > 0 {
                query = String(query.suffix(from: query.endIndex))
                print("query TEST: ",query)
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = query
            
            // request = NSMutableURLRequest(url: components.url!, cachePolicy: req.cachePolicy, timeoutInterval: req.timeout) as URLRequest
            request = URLRequest(url: components.url!, cachePolicy: req.cachePolicy, timeoutInterval: req.timeout)
            if !(req.body?.isEmpty ?? true) {
            let body = try? JSONSerialization.data(withJSONObject: req.body as Any, options: .prettyPrinted)
                request?.httpBody = body}
            
            let headers = [ "Content-Type": "application/json" ]
            request?.allHTTPHeaderFields = headers
            
        case .path:
            var query = ""
            
            req.parameters?.forEach { key, value in
                query = query + "\(key)=\(value)&"
            }
            
            if query.count > 0 {
                query = String(query.suffix(from: query.endIndex))
                print("query TEST: ",query)
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = query
            if let urlWithParams = URL(string: url.absoluteString + "?" + query) {
                request = URLRequest(url: urlWithParams, cachePolicy: req.cachePolicy, timeoutInterval: req.timeout)
            }else{
                request = URLRequest(url: components.url!, cachePolicy: req.cachePolicy, timeoutInterval: req.timeout)
            }
        }
        
        let headers = req.headers
        
        request!.allHTTPHeaderFields = headers
        request!.httpMethod = req.method.rawValue
        
        NetworkLogger.log(request: request!)
        
        return request!
    }
}
