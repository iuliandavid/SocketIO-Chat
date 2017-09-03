//
//  Message.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/2/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import SwiftyJSON

/// maps the Message object from the socketio API
/// ```javascript
/// const messageSchema = new Schema({
/// messageBody: String, default: "",
/// timeStamp: {type: Date, default: Date.now},
/// userId: {type: ObjectId, ref: 'User'},
/// channelId: {type: ObjectId, ref: 'Channel'},
/// userName: String, default: "",
/// userAvatar: String, default: "",
/// userAvatarColor: String, default: ""
/// });
/// ```
struct Message {
    
    public private(set) var message: String!
    public private(set) var userName: String!
    public private(set) var channelId: String!
    public private(set) var userAvatar: String!
    public private(set) var userAvatarColor: String!
    public private(set) var id: String!
    public private(set) var timestamp: String!
    
    static func buildMessage(fromJson item: JSON) -> Message {
        
        let message = item["messageBody"].stringValue
        let userName = item["userName"].stringValue
        let channelId = item["channelId"].stringValue
        let userAvatar = item["userAvatar"].stringValue
        let userAvatarColor = item["userAvatarColor"].stringValue
        let id = item["id"].stringValue
        let timestamp = item["timestamp"].stringValue
        
        let newMessage = Message(message: message, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timestamp)
        
        return newMessage
    }
}
