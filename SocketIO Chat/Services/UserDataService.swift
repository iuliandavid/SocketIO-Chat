//
//  UserDataService.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/29/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    
    public private(set) var avatarColor = ""
    
    public private(set) var avatarName = ""
    
    public private(set) var email = ""
    
    public private(set) var name = ""
    
    //JSON names
    private let avatarColorJSON = "avatarColor"
    private let avatarNameJSON = "avatarName"
    private let nameJSON = "name"
    private let emailJSON = "email"
    private let idJSON = "_id"
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setUserData(json: JSON) {
        let id = json[idJSON].stringValue
        let email = json[emailJSON].stringValue
        let avColor = json[avatarColorJSON].stringValue
        let avName = json[avatarNameJSON].stringValue
        let name = json[nameJSON].stringValue
        self.id = id
        self.avatarColor = avColor
        self.avatarName = avName
        self.email = email
        self.name = name
    }
    
    func buildUserData(email: String, name: String, avatarName: String, color: String) -> [String: Any] {
        return [
            nameJSON: name,
            emailJSON: email.lowercased(),
            avatarNameJSON: avatarName,
            avatarColorJSON: color
        ]
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String) -> UIColor {
        let scaner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scaner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scaner.scanUpToCharacters(from: comma, into: &r)
        scaner.scanUpToCharacters(from: comma, into: &g)
        scaner.scanUpToCharacters(from: comma, into: &b)
        scaner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        guard let rUnwrapped = r, let gUnwrapped = g,
        let bUnwrapped = b, let aUnwrapped = a
        else {
            return defaultColor
        }
        
        let rFloat: CGFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat: CGFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat: CGFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat: CGFloat = CGFloat(aUnwrapped.doubleValue)
        
        return UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
    }
}
