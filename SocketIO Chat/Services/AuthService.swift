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
}

extension AuthService {
    func getRegistrationUrl(_ baseURL: String? = Constants.UrlConstants.BASE_URL) -> URL {
        guard let baseURL = baseURL, let url = URL(string: "\(baseURL)\(Constants.UrlConstants.REGISTER_ENDPOINT)") else {
           fatalError()
        }
        
        return url
    }
}
