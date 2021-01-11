//
//  BasRequest.swift
//  TaskTracker
//
//  Created by Harsha on 24/10/19.
//

import Foundation

protocol BasRequest: RequestProtocol {}

extension BasRequest {
    var baseUrl: URL {
        let TaskTrackerBaseUrl = NetworkConstants.ConfigurationAPI.TaskTrackerBaseURL
        return URL(string: TaskTrackerBaseUrl)!
    }
    
    var headers: HeadersDict {
        return ["Content-Type": "application/json"]
    }
    
    var timeout: TimeInterval {
        let timeoutInterval: String = NetworkConstants.ConfigurationAPI.extraTimeIntervel
        return TimeInterval(timeoutInterval) ?? 60
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
    
    var query: DataType { return .path }
    
    var body: ParametersDict? {return nil}
}

protocol RequestProtocol {
    associatedtype ResponseType: Codable
    var baseUrl: URL{ get }
    var endpoint: String { get }
    var method: Method { get }
    var query:  DataType { get }
    var parameters: ParametersDict? { get }
    var headers: HeadersDict { get }
    var timeout: TimeInterval { get }
    var cachePolicy: NSURLRequest.CachePolicy { get }
    var body: ParametersDict? { get }
}

struct GeneralResponse: Codable {
    let status: String
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}
