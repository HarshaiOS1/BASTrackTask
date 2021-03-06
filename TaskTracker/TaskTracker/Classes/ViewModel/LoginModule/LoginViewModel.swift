//
//  LoginViewModel.swift
//  TaskTracker
//
//  Created by Harsha on 11/01/21.
//

import Foundation

class LogInViewModel: NSObject {
    var userDetails: UserData?
    var responseBody = [String : Any]()
    
    struct registerRequest: BasRequest {
        var endpoint: String {
            return NetworkConstants.ConfigurationAPI.registerPath
        }
        
        var method: Method {
            return .post
        }
        
        typealias ResponseType = GeneralResponse
        var query: DataType = .json
        var body: ParametersDict?
        var parameters: ParametersDict?
    }
    
    struct loginRequest: BasRequest {
        var endpoint: String {
            return NetworkConstants.ConfigurationAPI.loginPath
        }
        
        var method: Method {
            return .post
        }
        
        typealias ResponseType = GeneralResponse
        var query: DataType = .json
        var body: ParametersDict?
        var parameters: ParametersDict?
    }
    
    struct RegisterAPI {
        typealias CompletionHandler = (Bool, String?,Data?)-> Void
        func register(name : String, password: String, age:String,email: String, completion:@escaping CompletionHandler) {
            let bodyParms = ["name" : name,
                             "email":email,
                             "password": password,
                             "age":age,
            ]
            let req = registerRequest.init( body: bodyParms)
            print(req)
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
                    }
                } else {
                    completion(true, String(response.statusCode), nil)
                }
            }
            
        }
    }
    
    struct LoginAPI {
        typealias CompletionHandler = (Bool, String?,Data?)-> Void
        func login(email : String, password: String, completion:@escaping CompletionHandler) {
            let bodyParms = ["email" : email,
                             "password":password]
            let req = loginRequest.init( body: bodyParms)
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

extension LogInViewModel{
    typealias CompletionHandler = (Bool,[String: Any])-> Void
    
    func serviceCallForLogin(email:String, password:String, completion:@escaping CompletionHandler) {
        
        LoginAPI().login(email: email, password: password) { [weak self] (isSuccess, response, data) in
            if isSuccess {
                if NetworkConstants.positiveStatusCodes.contains(Int(response ?? "404") ?? 404) {
                    if let data = data {
                        do {
                            self?.userDetails = try JSONDecoder().decode(UserData.self, from: data)
                            UserDefaults.standard.set((self?.userDetails?.token ?? "") as String, forKey: UserDefaultsKey.TOKEN)
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
    
    func serviceCallForRegister(name: String, password: String, email: String, age: String, completion:@escaping CompletionHandler) {
        
        RegisterAPI().register(name: name, password: password, age: age, email: email) { [weak self] (isSuccess, response, data) in
            if isSuccess {
                if NetworkConstants.positiveStatusCodes.contains(Int(response ?? "404") ?? 404) {
                    if let data = data {
                        do {
                            self?.userDetails = try JSONDecoder().decode(UserData.self, from: data)
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
                    print(error.localizedDescription)
                }
                
            }
        }
    }
}
