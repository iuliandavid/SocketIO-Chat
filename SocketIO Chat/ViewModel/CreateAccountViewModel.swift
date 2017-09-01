//
//  CreateAccountViewModel.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/31/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation
import UIKit


class CreateAccountViewModel {
    
    //variables
    var avatarName:String {
        guard !UserDataService.instance.avatarName.isEmpty else {
            return "profileDefault"
        }
        return UserDataService.instance.avatarName
    }
    
    private var avatarColor = "[0.5, 0.5, 0.5, 1]"
    public private(set) var name:String?
    public private(set) var password:String?
    public private(set) var email:String?
    
    private var bgColor: UIColor?
    
    private let authService:AuthService = AuthServiceClient.sharedInstance
    
    func registerUser(completion: @escaping CompletionHandler) {
        guard let email = email, !email.isEmpty,
            let password = password, !password.isEmpty,
            let name = name, !name.isEmpty
            else {
                completion(false, "Invalid fields!")
                return
                
        }
        authService.registerUser(email: email, password: password) { [weak self] (success, error) in
            if success {
                self?.authService.loginUser(email: email, password: password, completion: { [weak self]  (success, error) in
                    if success {
                        guard let strongSelf = self else { return }
                        strongSelf.authService.createUser(name: name, email: email, avatarColor: strongSelf.avatarColor, avatarName: strongSelf.avatarName, completion: { (success, errorMessage) in
                            //announce that user was created
                            NotificationCenter.default.post(name: Constants.NOTIF_DATA_DID_CHANGE, object: nil)
                            completion(success, errorMessage)
                            
                        })
                    } else {
                        completion(success, error)
                    }
                })
            } else {
                
                completion(success, error)
            }
        }
    }
}

extension CreateAccountViewModel {
    
    func updateUser(newValue: String) {
        name = newValue
    }
    
    func updatePassword(newValue: String) {
        password = newValue
    }
    
    func updateEmail(newValue: String) {
        email = newValue
    }
    
    func generateRandomColor() -> UIColor? {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        return bgColor
    }
    
    func getBackgroundColor() -> UIColor {
        if bgColor == nil {
            if avatarName.contains("light") {
                return .lightGray
            } else {
                return .white
            }
        } else {
            return bgColor!
        }
    }
}
