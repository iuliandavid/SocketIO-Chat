//
//  MessageServiceClient.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/2/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Alamofire
import SwiftyJSON

/// Contains all the methods for communicating with SocketIO
/// The history results such as: all channels, all messages, etc are done with the REST methods
/// Realtime results(happening when the app is running) are done with the Websockets methods
class MessageServiceClient: MessageService {

    static let instance = MessageServiceClient()
    
    /// ALL the channels for the logged user
    var channels:Dynamic<[Channel]>
    
    /// The current selected channel
    var selectedChannel: Dynamic<Channel?>
    
    /// All the messages in the `selectedChannel`
    var messages:Dynamic<[Message]>
    
    /// Dictionary of user:channel that are currently typing
    var typingUsers:Dynamic<[String: String]> = Dynamic([:])
    
    /// Text binding for `usersTyping` endpoint
    var typingUsersText:Dynamic<String> = Dynamic("")
    
    private init() {
        channels = Dynamic([])
        selectedChannel = Dynamic(nil)
        messages = Dynamic([])
        getChannels()
        getMessages()
        getUsersTyping()
        
        //let mmy = testDict.reduce("") {(ac: String, r: (String,String)) -> String in
//        if r.1 == "1" {
//            return ac == "" ? r.0 : ac + " and " + r.0
//        } else {
//            return ac
//        }
//    }
        typingUsers.bindAndFire { (usersArray) in
            let res : (Int,String) = (0,"" )
            let (noOfUsersTyping, users) = usersArray.reduce(res) { (result, item: (String,String)) -> (Int,String) in
                let (user, channel) = item
                if user != UserDataService.instance.name && channel == self.selectedChannel.value?.id  {
                    return result.0 == 0 ? (1, user) : (result.0 + 1, "\(result.1), \(user)")
                } else {
                    return result
                }
            }
            switch noOfUsersTyping {
            case 0 : self.typingUsersText.value = ""
            case 1 : self.typingUsersText.value = "\(users) is typing"
            default : self.typingUsersText.value = "\(users) are typing"
            }
            
        }
        
    }
    
    
    func clearChannels() {
        channels.value.removeAll()
    }
    
    func clearMessages() {
        messages.value.removeAll()
    }
    func clearUsersTyping() {
        typingUsers.value.removeAll()
    }
}

// MARK: - REST methods
/// Historical results
extension MessageServiceClient {
    
    // MARK: - Channel related
    ///Retrieves all created channels
    /// - params completion
    func findAllChannels(completion: @escaping CompletionHandler) {
        guard let header = getHeaders() else {
            completion(false, "Invalid Credentials")
            return
        }
        
        let url = getAllChannelsURL()
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { [weak self] (response) in
            guard let resultCode = response.response?.statusCode else {
                completion(false, "cannot connect to server")
                return
            }
            
            if response.result.error == nil && (200..<300).contains(resultCode)   {
                
                //SwiftyJSON
                guard let data = response.data else {
                    return
                }
                let json = JSON(data: data)
                self?.setChannels(json: json)
                
                completion(true, nil)
            } else {
                //The server may return Success even if there is an error
                guard let result = response.result.value else {
                    completion(false, "unhandled error")
                    return
                }
                debugPrint(result)
                completion(false, "cannot login")
            }
        }
    }
    
    private func setChannels(json: JSON) {
        guard let channelArray = json.array else {
            return
        }
        
        channelArray.forEach { channels.value.append(Channel(from: $0)) }
    }
    
    
    // MARK: - Messages related
    func findAllMessages(forChannelId channelId: String, completion: @escaping CompletionHandler) {
        guard let header = getHeaders() else {
            completion(false, "Invalid Credentials")
            return
        }
        
        let url = getAllMessagesForChannelURL(channelId: channelId)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { [weak self] (response) in
            guard let resultCode = response.response?.statusCode else {
                completion(false, "cannot connect to server")
                return
            }
            
            if response.result.error == nil && (200..<300).contains(resultCode)   {
                
                //SwiftyJSON
                guard let data = response.data else {
                    return
                }
                let json = JSON(data: data)
                self?.setMessages(json: json)
                
                completion(true, nil)
            } else {
                //The server may return Success even if there is an error
                guard let result = response.result.value else {
                    completion(false, "unhandled error")
                    return
                }
                debugPrint(result)
                completion(false, "cannot login")
            }
        }
    }
    
    private func setMessages(json: JSON) {
        //first clear the array
        clearMessages()
        
        guard let messagesArray = json.array else {
            return
        }
        
        messagesArray.forEach { messages.value.append(Message.buildMessage(fromJson: $0)) }
    }
}

// MARK: - WebSocket methods
/// Realtime results
extension MessageServiceClient {
    
    // MARK: - Channel related
    /// Listener for realtime channel creation
    func getChannels() {
        SocketService.instance.getChannels { (_, _) in
        }
    }
    
    /// Creates a new channel
    /// - parameter channelName: The event to create.
    /// - parameter channelDescription: The description of the channel
    /// - parameter completion: a handler returning the status of the channel creation
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success, error) in
            completion(true, nil)
        }
        
    }
    
    
    // MARK: - Messages related
    // MARK: - Channel related
    /// Listener for realtime message creation
    func getMessages() {
        guard let channelId = selectedChannel.value?.id else {
            return
        }
        SocketService.instance.getMessages(channelID: channelId) { [unowned self] (success, err, message) in
            if success {
                self.messages.value.append(message!)
            }
        }
    }
    
    /// Creates a new channel
    ///
    /// - parameter messageBody: The body of the message.
    /// - parameter channelId: The channel on which the message is posted
    /// - parameter completion: a handler returning the status of the message posting
    ///
    /// Calls
    ///
    ///     SocketService.instance.postMessage(messageBody: , userId: , channelId: , userName: , userAvatar: , userAvatarColor: , completion: )
    /// The rest of the parameters are retrieved from UserDataService
    func sendMessage(messageBody: String, channelId: String, completion: @escaping CompletionHandler) {
        let userId = UserDataService.instance.id
        let userName = UserDataService.instance.name
        let userAvatar = UserDataService.instance.avatarName
        let userAvatarColor = UserDataService.instance.avatarColor
        SocketService.instance.postMessage(messageBody: messageBody, userId: userId, channelId: channelId, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor) { (success, err) in
            completion(success, err)
        }
    }
    
    // MARK: - Channel related
    /// Listener for realtime channel creation
    func getUsersTyping() {
        SocketService.instance.getTypingUsers {[unowned self] (typingusers) in
            self.typingUsers.value = typingusers
        }
    }
    
    /// Sets if the user is typing or finished typing
    func setUserTyping(typing: Bool) {
        let userName = UserDataService.instance.name
        guard let channelId = selectedChannel.value?.id else { return }
        SocketService.instance.setUserTyping(userName: userName, typing: typing, channelId: channelId) { (_, _) in
        }
    }
}
