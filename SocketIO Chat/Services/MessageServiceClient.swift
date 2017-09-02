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
class MessageServiceClient: MessageService {

    static let instance = MessageServiceClient()
    
    var channels:Dynamic<[Channel]>
    
    var selectedChannel: Dynamic<Channel?>
    
    private init() {
        channels = Dynamic([])
        selectedChannel = Dynamic(nil)
        getChannels()
    }
    
    
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
    
    func clearChannels() {
        channels.value.removeAll()
    }
}

// MARK - WebSocket methods
extension MessageServiceClient {
    func getChannels() {
        SocketService.instance.getChannels { (success, _) in
            print("called")
        }
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success, error) in
            completion(true, nil)
        }
        
    }
}
