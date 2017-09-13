//
//  SocketService.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/2/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
//debug purposes
//    private let socket = SocketIOClient(socketURL: URL(string: Constants.UrlConstants.BASE_URL)!, config: [.log(true), .compress])
    
    private let socket = SocketIOClient(socketURL: URL(string: Constants.UrlConstants.baseUrl)!)
    
    override init() {
        super.init()
    }
    
    ///Connect
    func establishConnection() {
        socket.connect()
    }
    
    ///Disconnect
    func closeConnection() {
        socket.disconnect()
    }
    
    // MARK: - Endpoints
    // MARK: - Channel Related
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit(Constants.Sockets.newChannel, channelName, channelDescription)
        completion(true, nil)
    }
    
    /// Subscribes to channel creation events
    func getChannels(completion: @escaping CompletionHandler ) {
        socket.on(Constants.Sockets.channelCreated) { (dataArray, _) in
            guard let channelName = dataArray[0] as? String,
                let channelDescription = dataArray[1] as? String,
                let channelId = dataArray[2] as? String else {
                    return
            }
            let channel = Channel(channelTitle: channelName, channelDescription: channelDescription, channelId: channelId)
            MessageServiceClient.instance.channels.value.append(channel)
            completion(true, nil)
        }
    }
    
    // MARK: - Messaging related
    ///```javascript
    ///client.on('newMessage', function(messageBody, userId, channelId, userName, userAvatar, userAvatarColor)
    ///```
    func postMessage(messageBody: String, userId: String, channelId: String, userName: String, userAvatar: String, userAvatarColor: String, completion: @escaping CompletionHandler) {
        socket.emit(Constants.Sockets.newMessage, messageBody, userId, channelId, userName, userAvatar, userAvatarColor)
        completion(true, nil)
    }
    
    /// Subscribes to channel creation events
    ///
    /// ```javascript
    ///io.emit("messageCreated",  msg.messageBody, msg.userId, msg.channelId, msg.userName, msg.userAvatar, msg.userAvatarColor, msg.id, msg.timeStamp)
    ///```
    ///
    /// - parameter completion: The callback that will execute when this event is received.
    ///
    func getMessages(channelID: String, completion: @escaping (_ message: Message) -> Void ) {
        socket.off(Constants.Sockets.messageCreated)
        socket.on(Constants.Sockets.messageCreated) { (dataArray, _) in
            
            Message.buildMessage(fromArray: dataArray) { (message) in
                guard let message = message else {
                    return
                }
                
                completion(message)
            } 
        }
    }
    ///
    /// Subscribes to typing user events
    ///
    /// ```javascript
    ///io.emit("userTypingUpdate", typingUsers, channelId)
    ///```
    ///
    /// - parameter completion: The callback that will execute when this event is received containing a dictionary of user:channel pairs.
    ///
    func getTypingUsers(completion: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on(Constants.Sockets.typingUsers) { (dataArray, _) in
            guard let typingUsers = dataArray[0] as? [String: String] else {
                return
            }
            completion(typingUsers)
        }
    }
    
    ///
    /// Emits an event if the user is typing or stopped typing
    ///
    /// ```javascript
    ///client.on("startType", function(userName, channelId)
    ///client.on("stopType", function(userName)
    ///```
    /// - parameter userName
    /// - parameter typing - Based on this is set the endpoint to emit message
    /// - parameter channel - The channel on which the user is typing
    /// - parameter completion: The callback that will execute when this event is received
    ///
    func setUserTyping(userName: String, typing:Bool, channelId: String, completion: @escaping CompletionHandler) {
        if typing {
            socket.emit(Constants.Sockets.startTyping, userName, channelId)
        } else {
            socket.emit(Constants.Sockets.stopTyping, userName)
        }
        completion(true, nil)
    }
}
