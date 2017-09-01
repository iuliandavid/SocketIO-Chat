
//
//  ChannelViewModel.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/31/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation
import UIKit

class ChannelViewModel {
    
    private let authService:AuthService
    
    public private(set) var loginTitle:String = ""
    
    public private(set) var imageName = Constants.DEFAULT_PROFILE_IMAGE
    
    public private(set) var bgColor:UIColor?
    
    init(authService: AuthService? = AuthServiceClient.sharedInstance ) {
        guard authService != nil else {
            fatalError()
        }
        
        self.authService = authService!
    }
    
    func userDataChanged(completion: @escaping UserProfileInfoHandler) {
        if authService.isLoggedIn {
            UserDataService.instance.getUserInfo(completion: {[weak self] (name, avatarName, bgColor) in
                guard let strongSelf = self else { fatalError() }
                strongSelf.loginTitle = UserDataService.instance.name
                strongSelf.imageName = UserDataService.instance.avatarName
                strongSelf.bgColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
                
                completion(strongSelf.loginTitle, strongSelf.imageName, strongSelf.bgColor)
            })
        } else {
            loginTitle = "Login"
            imageName = Constants.DEFAULT_PROFILE_IMAGE
            bgColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            completion(loginTitle, imageName, bgColor)
        }
        
    }
    
    func isLoggedIn() -> Bool {
        return authService.isLoggedIn
    }
}
