//
//  NetworkLogger.swift
//  TaskTracker
//
//  Created by wfh on 06/01/21.
//

import Foundation

func Logger<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    let value = object()
    let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
    let queue = Thread.isMainThread ? "UI" : "BG"
    print("<\(queue)> \(fileURL) \(function)[\(line)]: " + String(reflecting: value))
    print(value)
    #endif
}

struct NetworkLogger {
    
    static func log(request: URLRequest) {
        
        Logger("\n - - - - - - - - - - Request - - - - - - - - - - \n")
        defer { Logger("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        Logger(logOutput)
    }
    
    static func log(response data: Data?, response: URLResponse?, error: Error?) {
        Logger("\n - - - - - - - - - - Response - - - - - - - - - - \n")
        defer { Logger("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        if data != nil {
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: [])
            Logger(jsonData)
        }
        
        if error != nil {
            Logger(error)
        }
        
        if response != nil {
            Logger(response)
        }
    }
}
