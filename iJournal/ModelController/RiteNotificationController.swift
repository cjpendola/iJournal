//
//  NotificationController.swift
//  iJournal
//
//  Created by Colin Smith on 5/7/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import Foundation
import EventKit
import UserNotifications
import NotificationCenter

class RiteNotificationController {
    
    static let shared = RiteNotificationController()
    
    
    var dateFromPicker: Date?
    
    var currentAlarm = Date()

    var weekdayComponent = DateComponents(weekday: 0)
    
    var identifier = ""
    
    //MARK: - Event Kit Recurrence and Alarm
    /*func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil){
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = startDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                let recurrenceRule = EKRecurrenceRule.init(
                    recurrenceWith: .weekly,
                    interval: 1,
                    daysOfTheWeek: [EKRecurrenceDayOfWeek.init(EKWeekday.saturday)],
                    daysOfTheMonth: nil,
                    monthsOfTheYear: nil,
                    weeksOfTheYear: nil,
                    daysOfTheYear: nil,
                    setPositions: nil,
                    end: EKRecurrenceEnd.init(end:endDate)
                )
                
                event.recurrenceRules = [recurrenceRule]
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }*/
    
    /*private func createDate(date: String!, hours: Int!, minutes:Int! ) -> Date{
        var fullDateArr = date.components(separatedBy: "-")
        
        let startMonth: Int? = Int(fullDateArr[0])!
        let startDay: Int? = Int(fullDateArr[1])!
        let startYear: Int = Int(fullDateArr[2])!
        
        var dateComponents = DateComponents()
        dateComponents.year = startYear
        dateComponents.month = startMonth
        dateComponents.day = startDay
        dateComponents.timeZone = TimeZone(abbreviation: "MDT") // ELP Standard Time
        dateComponents.hour = hours
        dateComponents.minute = minutes
        
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents)
        
        return someDateTime!
    }*/
    
    //MARK: Alarm with Notifications
    
    func alarmSet(day: Int){
        switch day {
        case 0:
            weekdayComponent = DateComponents(weekday: 1)
            identifier = "Sunday"
        case 1:
            weekdayComponent = DateComponents(weekday: 2)
            identifier = "Monday"
        case 2:
            weekdayComponent = DateComponents(weekday: 3)
            identifier = "Tuesday"
        case 3:
            weekdayComponent = DateComponents(weekday: 4)
            identifier = "Wednesday"
        case 4:
            weekdayComponent = DateComponents(weekday: 5)
            identifier = "Thursday"
        case 5:
            weekdayComponent = DateComponents(weekday: 6)
            identifier = "Friday"
        case 6:
            weekdayComponent = DateComponents(weekday: 7)
            identifier = "Saturday"
            
        default: print("error")
        }
        print(weekdayComponent)
    }
    
    
    func repeatNotification(string: String){
        let content = UNMutableNotificationContent()
        content.title = "Scheduled Notification from Rite"
        content.body = string
        content.categoryIdentifier = identifier
    
        
        let components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: dateFromPicker ?? Date())
        let hour = components.hour!
        let minute = components.minute!
        var specificComponents = DateComponents()
        specificComponents.weekday = weekdayComponent.weekday
        specificComponents.hour = hour
        specificComponents.minute = minute
        specificComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: specificComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error in weekly reminder: \(error.localizedDescription)")
            }
        }
        
        dump(specificComponents)
    }

    
    
    
    func alarmTime(time: Date){
        
    }
    
    
    func scheduleAlarm(){
        
    }
    
    
 
    
    
}
