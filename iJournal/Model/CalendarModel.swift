//
//  CalendarModel.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/30/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import Foundation

protocol CalendarDelgate {
    
}

class CalendarPicker {
    
    var delegate: CalendarDelgate?
    
    
    func arrayOfDates() -> NSArray {
        
        let numberOfDays: Int = 14
        let startDate = Date()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "EEE d/M"
        let calendar = Calendar.current
        var offset = DateComponents()
        var dates: [Any] = [formatter.string(from: startDate)]
        
        for i in 1..<numberOfDays {
            offset.day = i
            let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
            let nextDayString = formatter.string(from: nextDay!)
            dates.append(nextDayString)
        }
        return dates as NSArray
    }
    
}

