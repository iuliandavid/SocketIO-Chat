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
        let id = item["_id"].stringValue
        let timestamp = item["timeStamp"].stringValue
        
        let newMessage = Message(message: message, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timestamp)
        
        return newMessage
    }
    
    static func buildMessage(fromArray dataArr: [Any], completion: @escaping (Message?) -> ()) {
//        msg.messageBody, msg.userId, msg.channelId, msg.userName, msg.userAvatar, msg.userAvatarColor, msg.id, msg.timeStamp
        guard let messageBody = dataArr[0] as? String,
              let channelId = dataArr[2] as? String,
        let userName = dataArr[3] as? String,
        let userAvatar = dataArr[4] as? String,
        let userAvatarColor = dataArr[5] as? String,
        let id = dataArr[6] as? String,
        let timestamp = dataArr[7] as? String
        else {
            completion(nil)
            return
        }
        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timestamp)
        print(message)
        completion(message)
        
    }
}
