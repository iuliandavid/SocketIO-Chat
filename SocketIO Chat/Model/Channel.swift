//
//  Channel.swift
//  SocketIO Chat
//
//  Created by iulian david on 9/2/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import Foundation
import SwiftyJSON

/// maps the Channel object from the socketio API
/// ``` javascript
/// const channelSchema = new Schema({
/// name: String, default: "",
/// description: String, default: ""
/// });
/// ```
struct Channel {
    
    public private(set) var channelTitle: String!
    public private(set) var channelDescription: String!
    public private(set) var id: String!
    
    //JSON mapping
    private static let titleString = "name"
    private static let descString = "description"
    private static let idString = "_id"
    
    
    public static func buildChannel(from item: JSON) -> Channel {
        
        let channelTitle = item[titleString].stringValue
        let channelDescription = item[descString].stringValue
        let id = item[idString].stringValue
        return Channel(channelTitle: channelTitle, channelDescription: channelDescription, id: id)
    }
    
    public static func buildChannelJSON(title: String, description: String?) -> [String: Any] {
        return  [
            titleString : title,
            descString: description ?? ""
        ]
    }
}
