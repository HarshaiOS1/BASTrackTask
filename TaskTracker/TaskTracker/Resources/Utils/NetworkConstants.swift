//
//  NetworkConstants.swift
//  TaskTracker
//
//  Created by Harsha on 06/01/21.
//

import Foundation

struct NetworkConstants {
    
    struct ConfigurationAPI {
        static let TaskTrackerBaseURL        =   "https://api-nodejs-todolist.herokuapp.com"
        static let registerPath = "/user/register"
        static let loginPath = "user/login"
        static let logoutPath = "user/logout"
        static let getTaskPath = "task/"
        static let extraTimeIntervel    = "60"
    }
    
    static let positiveStatusCodes = [200,201,202,203,204]
}
