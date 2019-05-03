//
//  CalendarModel.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/30/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import Foundation

protocol YearDelgate {
    
}
protocol MonthDelegate {
    
}

class YearPicker {
    
    var delegate: YearDelgate?
    
    /*func arrayOfYears() -> NSArray {
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
    }*/
    
    
    func arrayOfYears() -> NSArray {
        var year: [String] = []
        for i in 2019..<2030 {
            year.append(String (i))
        }
        return year as NSArray
    }
}



class MonthPicker {
    var delegate: MonthDelegate?
    
    func arrayOfMonths() -> NSArray {
        let month: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        return month as NSArray
    }
    
    
}

