
//
//  ChannelViewModel.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/31/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation

class ChannelViewModel {
    
    private let authService:AuthService
    
    public private(set) var loginTitle:String = ""
    
    public private(set) var imageName = Constants.DEFAULT_PROFILE_IMAGE
    
    init(authService: AuthService? = AuthServiceClient.sharedInstance ) {
        guard authService != nil else {
            fatalError()
        }
        
        self.authService = authService!
    }
    
    func userDataChanged() {
        if authService.isLoggedIn {
            loginTitle = UserDataService.instance.name
            imageName = UserDataService.instance.avatarName
        } else {
            loginTitle = "Login"
            imageName = Constants.DEFAULT_PROFILE_IMAGE
        }
    }
}
