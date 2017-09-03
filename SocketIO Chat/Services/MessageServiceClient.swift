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
    
    private init() {
        channels = Dynamic([])
        selectedChannel = Dynamic(nil)
        messages = Dynamic([])
        getChannels()
        
    }
    
    
    func clearChannels() {
        channels.value.removeAll()
    }
    
    func clearMessages() {
        messages.value.removeAll()
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
    
}
