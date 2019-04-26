//
//  PushNotificationManager.swift
//  Tiki
//
//  Created by Carlos Pendola on 4/2/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

import Foundation
import OneSignal

class PushNotificationManager {
    static let shared = PushNotificationManager()
    
    func notifyProfileWith(playerId: String, followerUsername: String) {
        let jsonDict : [String : Any] = [
            "app_id" : "a9cb7705-ba51-4325-9272-1fb5aff0e639",
            "include_player_ids": [playerId],
            "headings" : ["en" : "Nice."],
            "contents" : ["en" : "\(followerUsername) just followed you."]
        ]
        OneSignal.postNotification(jsonDict, onSuccess: nil, onFailure: { (error) in
            if let error = error {
                print(error, error.localizedDescription)
            }
        })
    }
}
