//
//  NotifcationSettingsViewController.swift
//  iJournal
//
//  Created by Colin Smith on 5/7/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class NotifcationSettingsViewController: UIViewController, UITextViewDelegate {

    var selectedDay: Int?
    
    //MARK: - Outlets

    @IBOutlet weak var notificationPrompt: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var promptTextView: UITextView!
    
    var descriptionString : String?
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promptTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        descriptionString = promptTextView.text
    }
   
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
      
    }
    
    
    @IBAction func daySelectValueChanged(_ sender: UISegmentedControl) {
        RiteNotificationController.shared.alarmSet(day: sender.selectedSegmentIndex)
        selectedDay = sender.selectedSegmentIndex
       
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        RiteNotificationController.shared.dateFromPicker = sender.date
        
    }
    
    
    @IBAction func scheduleButtonPressed(_ sender: UIButton) {
        guard let string = descriptionString else {return}
        RiteNotificationController.shared.repeatNotification(string: string)
         //RiteNotificationController.shared.scheduleAlarm()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     
     */
    
    
    
    
}
