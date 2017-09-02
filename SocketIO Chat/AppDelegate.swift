//
//  AppDelegate.swift
//  SocketIO Chat
//
//  Created by iulian david on 8/25/17.
//  Copyright © 2017 iulian david. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.appendChannels), userInfo: nil, repeats: false)
        
        return true
    }

    @objc func appendChannels() {
        let client = MessageServiceClient.instance
//        for i in 1...10 {
//            MessageServiceClient.instance.channels.value.append(Channel(channelTitle: "channel\(i)", channelDescription: "description", id: "\(i)"))
//        }
        client.selectedChannel.value = client.channels.value[2]
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketService.instance.establishConnection()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SocketService.instance.closeConnection()
    }
}

