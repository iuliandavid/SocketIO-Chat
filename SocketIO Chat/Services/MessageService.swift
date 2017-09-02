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
    var channels:[Channel] {get}
    
    func findAllChannels(completion: @escaping CompletionHandler)
    
    func getAllChannelsURL(baseURL: String?) -> URL
    
    func getHeaders() -> [String: String]?
}

extension MessageService {
    func getAllChannelsURL(baseURL: String? = Constants.UrlConstants.BASE_URL) -> URL {
        guard let baseURL = baseURL, let url = URL(string: "\(baseURL)\(Constants.UrlConstants.CHANNEL_LIST_ENDPOINT)") else {
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
}
