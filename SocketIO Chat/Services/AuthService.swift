//
//  AuthService.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/28/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation

protocol AuthService {
    
//    var instance: AuthService {get}
    
    var isLoggedIn: Bool {get set}
    
    var authToken: String? {get set}
    
    var userEmail: String? {get set}
    
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler)
    
    func getRegistrationUrl(_ baseURL: String?) -> URL
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler)
    
    func getLoginUrl(_ baseURL: String?) -> URL
    
    func createUser(name: String, email: String, avatarColor: String, avatarName: String, completion: @escaping CompletionHandler)
    
    func getAddUserUrl(_ baseURL: String?) -> URL
}

extension AuthService {
    func getRegistrationUrl(_ baseURL: String? = Constants.UrlConstants.BASE_URL) -> URL {
        guard let baseURL = baseURL, let url = URL(string: "\(baseURL)\(Constants.UrlConstants.REGISTER_ENDPOINT)") else {
           fatalError()
        }
        
        return url
    }
    
    func getLoginUrl(_ baseURL: String? = Constants.UrlConstants.BASE_URL) -> URL {
        guard let baseURL = baseURL, let url = URL(string: "\(baseURL)\(Constants.UrlConstants.LOGIN_ENDPOINT)") else {
            fatalError()
        }
        
        return url
    }
    
    func getAddUserUrl(_ baseURL: String? = Constants.UrlConstants.BASE_URL) -> URL {
        guard let baseURL = baseURL, let url = URL(string: "\(baseURL)\(Constants.UrlConstants.USER_ADD_ENDPOINT)") else {
            fatalError()
        }
        
        return url
    }
}
