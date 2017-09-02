//
//  Avatars.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/31/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation

enum AvatarType: String {
    case light
    case dark
}

///Model class for AvatarPickerVC
class AvatarsViewModel {
    
    public var type: AvatarType = .dark {
        didSet {
            updateAvatarsAray()
        }
    }
    
    private var darkAvatars: [String] = []
    
    private var lightAvatars: [String] = []
    
    public private(set) var avatars: [String] = []
    
    
    init() {
        for i in 0...27 {
            darkAvatars.append("dark\(i)")
            lightAvatars.append("light\(i)")
        }
        avatars = darkAvatars
    }
    
    fileprivate func updateAvatarsAray() {
        switch type {
        case .dark:
            avatars = darkAvatars
        case.light:
            avatars = lightAvatars
        }
    }
}
