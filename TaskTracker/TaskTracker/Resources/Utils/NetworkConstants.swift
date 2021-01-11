//
//  NetworkConstants.swift
//  TaskTracker
//
//  Created by wfh on 06/01/21.
//

import Foundation

struct NetworkConstants {
    
    struct ConfigurationAPI {
        static let TaskTrackerBaseURL        =   "https://api-nodejs-todolist.herokuapp.com"
        static let registerPath = "/user/register"
        static let extraTimeIntervel    = "60"
    }
    
//    static let tokenIdentifier  =   "token"
//    static let appId = "appId"
//    static let Appsessiontoken = "Appsessiontoken"
//    static let uniqueRandomNumber = "uniqueRandomNumber"
//    static let uniqueRRRandomNumber = "RRRuniqueRandom"
//    static let oldAccessToken = "oldAccessToken"
//    static let hybrisIphoneAppId = "IphoneApp"
    
    static let positiveStatusCodes = [200,201,202,203,204]
}
