//
//  Constants.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/27/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (_ Success: Bool, _ errorMessage: String?) -> ()

struct Constants {
    //Colors
    static let textPlaceholderColor = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)
    
    //Notifications
    static let NOTIF_DATA_DID_CHANGE = Notification.Name("notifDataChanged")
    
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
