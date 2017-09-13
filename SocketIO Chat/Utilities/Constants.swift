//
//  Constants.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/27/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (_ Success: Bool, _ errorMessage: String?) -> Void
typealias UserProfileInfoHandler = (_ loginTitle: String, _ imageName: String, _ bgColor: UIColor?) -> Void

struct Constants {
    //Colors
    static let textPlaceholderColor = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)
    
    //Notifications
    static let notifDataDidChange = Notification.Name("notifDataChanged")
    
    struct Segues {
        static let toLogin = "toLogin"
        static let toCreateAccount = "toCreateAccount"
        static let unwindToChannel = "unwindToChannel"
        static let toAvatarPicker = "toAvatarPicker"
    }
    
    struct Authentication {
        static let tokenKey = "token"
        static let loggedInKey = "loggedIn"
        static let userEmail = "email"
    }
    
    struct UrlConstants {
        static let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        static let baseUrl = "https://socketiochatchat.herokuapp.com/v1/"
        static let register = "account/register"
        static let login = "account/login"
        static let addUser = "user/add"
        static let findUserByEmail = "user/byEmail/"
        static let channels = "channel/"
        static let findMessagesByChannel = "message/byChannel/"
    }
    
    struct CellIdentifiers {
        static let avatarCellidentifier = "avatarCell"
        static let channelCellIdentifier = "channelCell"
        static let messageCellIdentifier = "messageCell"
    }
    
    static let defaultProfileImage = "menuProfileIcon"
    
    struct Sockets {
        static let newChannel = "newChannel"
        static let channelCreated = "channelCreated"
        static let newMessage = "newMessage"
        static let messageCreated = "messageCreated"
        static let typingUsers = "userTypingUpdate"
        static let startTyping = "startType"
        static let stopTyping = "stopType"
    }
}
