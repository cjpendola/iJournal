//
//  NotificationController.swift
//  iJournal
//
//  Created by Colin Smith on 5/7/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import Foundation
import EventKit

class RiteNotificationController {
    
    static let shared = RiteNotificationController()
    
    var date: Date?
    
    
    var sunday = EKAlarm(absoluteDate: date)
    
    var weekArray: [Notification] = [sunday]
    
    
}
