//
//  Notification.swift
//  iJournal
//
//  Created by Colin Smith on 5/7/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import Foundation
import EventKit

class RiteNotification {
    var fireTime: EKAlarm
    var enabled: Bool
    
    init(fireTime: EKAlarm, enabled: Bool = false){
        self.fireTime = fireTime
        self.enabled = enabled
        
    }
}
