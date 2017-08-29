//
//  AuthService.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/28/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation
import Alamofire

final class AuthServiceClient: AuthService {
    
//    var instance: AuthService {
//        return AuthServiceClient.sharedInstance
//    }
    
    
    static let sharedInstance = AuthServiceClient()
    
    //for user and token persistence
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: Constants.Authentication.LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: Constants.Authentication.LOGGED_IN_KEY)
        }
    }
    
    var authToken: String? {
        get {
            return defaults.string(forKey: Constants.Authentication.TOKEN_KEY)
        }
        set {
            defaults.set(newValue, forKey: Constants.Authentication.TOKEN_KEY)
        }
    }
    
    var userEmail: String? {
        get {
            return defaults.string(forKey: Constants.Authentication.USER_EMAIL)
        }
        set {
            defaults.set(newValue, forKey: Constants.Authentication.USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(getRegistrationUrl(), method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            print(response.result.value as Any)
            
            guard let resultCode = response.response?.statusCode else {
                completion(false, "cannot connect to server")
                return
            }
            if response.error == nil && (200..<300).contains(resultCode)   {
                
                print(response.result.value as Any)
                completion(true, nil)
            } else {
                //The server may return Success even if there is an error
                guard let result = response.result.value else {
                    completion(false, "unhandled error")
                    return
                }
                
                completion(false, result)
                debugPrint(response.error.debugDescription)
            }
        }
    }
}
