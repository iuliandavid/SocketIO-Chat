//
//  Constants.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/27/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool, _ errorMessage: String?) -> ()

struct Constants {
    struct Segues {
        static let TO_LOGIN = "toLogin"
        static let TO_CREATE_ACCOUNT = "toCreateAccount"
        static let UNWIND = "unwindToChannel"
        static let TO_AVATAR_PICKER = "toAvatarPicker"
    }
    
    struct Authentication {
        static let TOKEN_KEY = "token"
        static let LOGGED_IN_KEY = "loggedIn"
        static let USER_EMAIL = "email"
    }
    
    struct UrlConstants {
        static let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        static let BASE_URL = "https://socketiochatchat.herokuapp.com/v1/"
        static let REGISTER_ENDPOINT = "account/register"
        static let LOGIN_ENDPOINT = "account/login"
        static let USER_ADD_ENDPOINT = "user/add"
    }
    
    struct CellIdentifiers {
        static let AVATAR_CELL_IDENTIFIER = "avatarCell"
    }
}
