//
//  AuthService.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/28/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AuthServiceClient: AuthService {
    
    
    
//    var instance: AuthService {
//        return AuthServiceClient.sharedInstance
//    }
    
    
    static let sharedInstance = AuthServiceClient()
    
    private init() {
        
    }
    
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
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(getRegistrationUrl(), method: .post, parameters: body, encoding: JSONEncoding.default, headers: Constants.UrlConstants.header).responseString { (response) in
            
            guard let resultCode = response.response?.statusCode else {
                completion(false, "cannot connect to server")
                return
            }
            if response.result.error == nil && (200..<300).contains(resultCode)   {
                debugPrint(response.result.value as Any)
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
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(getLoginUrl(), method: .post, parameters: body, encoding: JSONEncoding.default, headers: Constants.UrlConstants.header).responseJSON { [unowned self] (response) in
            
            guard let resultCode = response.response?.statusCode else {
                completion(false, "cannot connect to server")
                return
            }
            if response.result.error == nil && (200..<300).contains(resultCode)   {
                //Standard way
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                //SwiftyJSON
                guard let data = response.data else {
                    return
                }
                let json = JSON(data: data)
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                self.isLoggedIn = true
                completion(true, nil)
            } else {
                //The server may return Success even if there is an error
                guard let result = response.result.value else {
                    completion(false, "unhandled error")
                    return
                }
                debugPrint(result)
                completion(false, "cannot login")
            }
        }
    }
    
    func createUser(name: String, email: String, avatarColor: String, avatarName: String, completion: @escaping CompletionHandler)  {
        
        guard let authToken = AuthServiceClient.sharedInstance.authToken else {
            return
        }
        
        let body = UserDataService.instance.buildUserData(email: email, name: name, avatarName: avatarName, color: avatarColor)

        
        var header:[String: String] = [
            "Authorization": "Bearer \(authToken)"
        ]
        Constants.UrlConstants.header.forEach { header[$0] = $1 }
        Alamofire.request(getAddUserUrl(), method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            guard let resultCode = response.response?.statusCode else {
                completion(false, "cannot connect to server")
                return
            }
            
            if response.result.error == nil && (200..<300).contains(resultCode)   {
                
                //SwiftyJSON
                guard let data = response.data else {
                    return
                }
                let json = JSON(data: data)
                UserDataService.instance.setUserData(json: json)
                
                completion(true, nil)
            } else {
                //The server may return Success even if there is an error
                guard let result = response.result.value else {
                    completion(false, "unhandled error")
                    return
                }
                debugPrint(result)
                completion(false, "cannot login")
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        let header: [String: String] = getAuthHeader {( success,error ) in
            if error != nil {
                completion(success, error!)
                return
            }
        }
        
        guard let userEmail = userEmail else {
            return
        }
        
        Alamofire.request(getUserByEmailUrl(userEmail: userEmail), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            //SwiftyJSON
            guard let data = response.data else {
                return
            }
            let json = JSON(data: data)
            UserDataService.instance.setUserData(json: json)
            
            completion(true, nil)
        }
    }
    
    private func getAuthHeader(completion: @escaping CompletionHandler) -> [String: String] {
        guard let authToken = AuthServiceClient.sharedInstance.authToken else {
            completion(false, "invalid credentials")
            return [:]
        }
        
        
        var header:[String: String] = [
            "Authorization": "Bearer \(authToken)"
        ]
        Constants.UrlConstants.header.forEach { header[$0] = $1 }
        return header
    }
}
