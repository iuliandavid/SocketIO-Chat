//
//  MessageService.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/2/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation

protocol MessageService {
    
    //The list of user registered channels
    var channels:Dynamic<[Channel]> {get}
    
    var selectedChannel: Dynamic<Channel?> {get set}
    
    var messages:Dynamic<[Message]> {get}
    
    var typingUsers:Dynamic<[String: String]> {get}
    
    var typingUsersText:Dynamic<String> {get}
    
    var unreadChannels:Dynamic<[String]> {get}
    
    func findAllChannels(completion: @escaping CompletionHandler)
    
    func getAllChannelsURL(baseURL: String?) -> URL
    
    func getHeaders() -> [String: String]?
    
    func getChannels()
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler)
    
    func clearChannels()
    
    func findAllMessages(forChannelId: String, completion: @escaping CompletionHandler)
    
    /// Returning all the messages for selected channel
    /// javascript API endpoint  `/v1/message/byChannel/:channelId`
    func getAllMessagesForChannelURL(channelId: String, baseURL: String?) -> URL
    
    func getMessages()
    
    func sendMessage(messageBody: String, channelId: String, completion: @escaping CompletionHandler)
    
    func clearMessages()
    
    func setUserTyping(typing: Bool)
}

extension MessageService {
    func getAllChannelsURL(baseURL: String? = Constants.UrlConstants.baseUrl) -> URL {
        guard let baseURL = baseURL, let url = URL(string: "\(baseURL)\(Constants.UrlConstants.channels)") else {
            fatalError()
        }
        
        return url
    }
    
    func getHeaders() -> [String: String]? {
        guard let authToken = AuthServiceClient.sharedInstance.authToken else {
            return nil
        }
        
        var header:[String: String] = [
            "Authorization": "Bearer \(authToken)"
        ]
        Constants.UrlConstants.header.forEach { header[$0] = $1 }
        return header
    }
    
    func getAllMessagesForChannelURL(channelId: String, baseURL: String? = Constants.UrlConstants.baseUrl) -> URL {
        guard let baseURL = baseURL, let url = URL(string: "\(baseURL)\(Constants.UrlConstants.findMessagesByChannel)\(channelId)") else {
            fatalError()
        }
        
        return url
    }
}
