//
//  DashboardViewModel.swift
//  TaskTracker
//
//  Created by Harsha on 12/01/21.
//

import Foundation

class DashboardViewModel: NSObject {
    
    var completedTaskData:[Datum] = []
    var openTaskData:[Datum] = []
    var allTasks:TaskData?
    var responseBody = [String : Any]()
    
    struct LogoutRequest: BasRequest {
        var parameters: ParametersDict?
        
        var endpoint: String {
            return NetworkConstants.ConfigurationAPI.logoutPath
        }
        
        var method: Method {
            return .post
        }
        typealias ResponseType = GeneralResponse
        var headers: HeadersDict
    }
    
    struct GetTaskRequest: BasRequest {
        var parameters: ParametersDict?
        
        var endpoint: String {
            return NetworkConstants.ConfigurationAPI.getTaskPath
        }
        
        var method: Method {
            return .get
        }
        var query: DataType = .path
        typealias ResponseType = GeneralResponse
        var headers: HeadersDict
    }
    
    struct EditTaskRequest: BasRequest {
        var endpoint: String
        
        var parameters: ParametersDict?
            
        var method: Method {
            return .put
        }
        var query: DataType = .json
        typealias ResponseType = GeneralResponse
        var headers: HeadersDict
        var body: ParametersDict?
    }
    
    struct AddTaskRequest: BasRequest {
        var endpoint: String
        
        var parameters: ParametersDict?
            
        var method: Method {
            return .post
        }
        var query: DataType = .json
        typealias ResponseType = GeneralResponse
        var headers: HeadersDict
        var body: ParametersDict?
    }
    
    struct DeleteTaskRequest: BasRequest {
        var parameters: ParametersDict?
        
        var endpoint: String

        var method: Method {
            return .delete
        }
        var query: DataType = .path
        var headers: HeadersDict

        typealias ResponseType = GeneralResponse
    }
    
    struct GetTasksAPI {
        typealias CompletionHandler = (Bool, String?,Data?)-> Void
        func getCompeltedTasks(completion:@escaping CompletionHandler) {
            if let token = UserDefaults.standard.value(forKey: UserDefaultsKey.TOKEN) {
                let header = ["Authorization": "Bearer \(token)"]
                let req = GetTaskRequest.init(headers: header)
                SessionSingleton.shared.requestForNetwork().request(req: req) { (data, response, error) in
                    guard let response = response as? HTTPURLResponse else { return completion(false, nil, nil) }
                    if error == nil {
                        if let data = data {
                            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                            print(string1)
                            if NetworkConstants.positiveStatusCodes.contains(response.statusCode) {
                                completion(true, String(response.statusCode), data)
                            } else {
                                completion(false, String(response.statusCode), data)
                            }
                        } else {
                            completion(false, String(response.statusCode), nil)
                        }
                    } else {
                        completion(false, String(response.statusCode), nil)
                    }
                }
            }
        }
    }
    
    struct EditTasksAPI {
        typealias CompletionHandler = (Bool, String?,Data?)-> Void
        func editTasks(completed: Bool,taskId:String, completion:@escaping CompletionHandler) {
            if let token = UserDefaults.standard.value(forKey: UserDefaultsKey.TOKEN) {
                let header = ["Authorization": "Bearer \(token)"]
                let bodyParms = ["completed" : completed]
                let req = EditTaskRequest.init(endpoint: NetworkConstants.ConfigurationAPI.getTaskPath+taskId, headers: header, body: bodyParms)
                SessionSingleton.shared.requestForNetwork().request(req: req) { (data, response, error) in
                    guard let response = response as? HTTPURLResponse else { return completion(false, nil, nil) }
                    if error == nil {
                        if let data = data {
                            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                            print(string1)
                            if NetworkConstants.positiveStatusCodes.contains(response.statusCode) {
                                completion(true, String(response.statusCode), data)
                            } else {
                                completion(false, String(response.statusCode), data)
                            }
                        } else {
                            completion(false, String(response.statusCode), nil)
                        }
                    } else {
                        completion(false, String(response.statusCode), nil)
                    }
                }
            }
        }
    }
    
    struct AddTaskAPI {
        typealias CompletionHandler = (Bool, String?,Data?)-> Void
        func addTask(description:String, completion:@escaping CompletionHandler) {
            if let token = UserDefaults.standard.value(forKey: UserDefaultsKey.TOKEN) {
                let header = ["Authorization": "Bearer \(token)"]
                let bodyParms = ["description" : description]
                let req = AddTaskRequest.init(endpoint: NetworkConstants.ConfigurationAPI.getTaskPath, headers: header, body: bodyParms)
                SessionSingleton.shared.requestForNetwork().request(req: req) { (data, response, error) in
                    guard let response = response as? HTTPURLResponse else { return completion(false, nil, nil) }
                    if error == nil {
                        if let data = data {
                            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                            print(string1)
                            if NetworkConstants.positiveStatusCodes.contains(response.statusCode) {
                                completion(true, String(response.statusCode), data)
                            } else {
                                completion(false, String(response.statusCode), data)
                            }
                        } else {
                            completion(false, String(response.statusCode), nil)
                        }
                    } else {
                        completion(false, String(response.statusCode), nil)
                    }
                }
            }
        }
    }
    
    struct DeleteTasksAPI {
        typealias CompletionHandler = (Bool, String?,Data?)-> Void
        func deleteTasks(taskId:String, completion:@escaping CompletionHandler) {
            if let token = UserDefaults.standard.value(forKey: UserDefaultsKey.TOKEN) {
                let header = ["Authorization": "Bearer \(token)"]
                let req = DeleteTaskRequest.init(endpoint: NetworkConstants.ConfigurationAPI.getTaskPath+taskId, headers: header)
                SessionSingleton.shared.requestForNetwork().request(req: req) { (data, response, error) in
                    guard let response = response as? HTTPURLResponse else { return completion(false, nil, nil) }
                    if error == nil {
                        if let data = data {
                            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                            print(string1)
                            if NetworkConstants.positiveStatusCodes.contains(response.statusCode) {
                                completion(true, String(response.statusCode), data)
                            } else {
                                completion(false, String(response.statusCode), data)
                            }
                        } else {
                            completion(false, String(response.statusCode), nil)
                        }
                    } else {
                        completion(false, String(response.statusCode), nil)
                    }
                }
            }
        }
    }
    
    struct LogoutAPI {
        typealias CompletionHandler = (Bool)-> Void
        func logOut(completion:@escaping CompletionHandler){
            if let token = UserDefaults.standard.value(forKey: UserDefaultsKey.TOKEN) {
                let header = ["Authorization": "Bearer \(token)"]
                let req = LogoutRequest.init(headers: header)
                SessionSingleton.shared.requestForNetwork().request(req: req) { (data, response, error) in
                    guard let response = response as? HTTPURLResponse else {
                        return completion(false)
                    }
                    if error == nil {
                        if NetworkConstants.positiveStatusCodes.contains(response.statusCode) {
                            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.TOKEN)
                            return completion(true)
                        }
                    }
                }
            }
        }
    }
}

extension DashboardViewModel{
    typealias CompletionHandler = (Bool,[String: Any])-> Void
    
    func getTasksList(completion:@escaping CompletionHandler) {
        
        GetTasksAPI().getCompeltedTasks() { [weak self] (isSuccess, response, data) in
            if isSuccess {
                if NetworkConstants.positiveStatusCodes.contains(Int(response ?? "404") ?? 404) {
                    if let data = data {
                        do {
                            self?.completedTaskData.removeAll()
                            self?.openTaskData.removeAll()
                            self?.allTasks = try JSONDecoder().decode(TaskData.self, from: data)
                            if let tasks = self?.allTasks {
                                if tasks.count ?? 0 > 0 {
                                    if let itemsList = tasks.data {
                                        for item in itemsList {
                                            if item.completed ?? false {
                                                self?.completedTaskData.append(item)
                                            } else {
                                                self?.openTaskData.append(item)
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            completion(true, [:])
                        } catch {
                            print(error)
                            completion(false, [:])
                        }
                        
                    } else {
                        completion(false, [:])
                    }
                } else {
                    completion(false, [:])
                }
            } else{
                do {
                    self?.responseBody = try (JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] ?? [:])
                    completion(false, self?.responseBody ?? [:])
                } catch {
                    completion(false, self?.responseBody ?? [:])
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func editTask(completed: Bool, taskId:String, completion:@escaping CompletionHandler) {
        
        EditTasksAPI().editTasks(completed: completed, taskId: taskId) { [weak self] (isSuccess, response, data) in
            if isSuccess {
                if NetworkConstants.positiveStatusCodes.contains(Int(response ?? "404") ?? 404) {
                    completion(true,[:])
                } else {
                    completion(false, [:])
                }
            } else{
                do {
                    self?.responseBody = try (JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] ?? [:])
                    completion(false, self?.responseBody ?? [:])
                } catch {
                    completion(false, self?.responseBody ?? [:])
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func addTask(description:String, completion:@escaping CompletionHandler) {
        
        AddTaskAPI().addTask(description: description) { [weak self] (isSuccess, response, data) in
            if isSuccess {
                if NetworkConstants.positiveStatusCodes.contains(Int(response ?? "404") ?? 404) {
                    completion(true,[:])
                } else {
                    completion(false, [:])
                }
            } else{
                do {
                    self?.responseBody = try (JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] ?? [:])
                    completion(false, self?.responseBody ?? [:])
                } catch {
                    completion(false, self?.responseBody ?? [:])
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func deletetTask(taskId:String, completion:@escaping CompletionHandler) {
        
        DeleteTasksAPI().deleteTasks(taskId: taskId) { [weak self] (isSuccess, response, data) in
            if isSuccess {
                if NetworkConstants.positiveStatusCodes.contains(Int(response ?? "404") ?? 404) {
                    completion(true,[:])
                } else {
                    completion(false, [:])
                }
            } else{
                do {
                    self?.responseBody = try (JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] ?? [:])
                    completion(false, self?.responseBody ?? [:])
                } catch {
                    completion(false, self?.responseBody ?? [:])
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func logOut(completion:@escaping CompletionHandler) {
        LogoutAPI().logOut(){(isSuccess) in
            if isSuccess {
                completion(true, [:])
            } else {
                completion(false, [:])
            }
        }
    }
}
