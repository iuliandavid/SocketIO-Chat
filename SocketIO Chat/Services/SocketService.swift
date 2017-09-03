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
    
    private let socket = SocketIOClient(socketURL: URL(string: Constants.UrlConstants.BASE_URL)!)
    
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
        socket.emit(Constants.Sockets.NEW_CHANNEL, channelName, channelDescription)
        completion(true, nil)
    }
    
    /// Subscribes to channel creation events
    func getChannels(completion: @escaping CompletionHandler ) {
        socket.on(Constants.Sockets.CHANNEL_CREATED) { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String,
                let channelDescription = dataArray[1] as? String,
                let channelId = dataArray[2] as? String else {
                    return
            }
            let channel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId)
            MessageServiceClient.instance.channels.value.append(channel)
            completion(true, nil)
        }
    }
    
    // MARK: - Messaging related
}


