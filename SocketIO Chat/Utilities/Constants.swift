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
typealias UserProfileInfoHandler = (_ loginTitle: String, _ imageName: String, _ bgColor: UIColor?) -> ()

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
        static let USER_BY_EMAIL_ENDPOINT = "user/byEmail/"
        static let CHANNEL_LIST_ENDPOINT = "channel/"
        static let MESSAGES_CHANNEL_ENDPOINT = "message/byChannel/"
    }
    
    struct CellIdentifiers {
        static let AVATAR_CELL_IDENTIFIER = "avatarCell"
        static let CHANNEL_CELL_IDENTIFIER = "channelCell"
        static let MESSAGE_CELL_IDENTIFIER = "messageCell"
    }
    
    static let DEFAULT_PROFILE_IMAGE = "menuProfileIcon"
    
    struct Sockets {
        static let NEW_CHANNEL = "newChannel"
        static let CHANNEL_CREATED = "channelCreated"
        static let NEW_MESSAGE = "newMessage"
        static let MESSAGE_CREATED = "messageCreated"
        static let TYPING_USERS = "userTypingUpdate"
        static let START_TYPING = "startType"
        static let STOP_TYPING = "stopType"
    }
}
