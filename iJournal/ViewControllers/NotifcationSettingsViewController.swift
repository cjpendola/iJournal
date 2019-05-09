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
    
    @IBOutlet weak var itemOutlet: UIBarButtonItem!
    //MARK: - Outlets

    @IBOutlet weak var notificationPrompt: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var promptTextView: UITextView!
    
    @IBOutlet weak var menu: UIBarButtonItem!
    
    var descriptionString : String?
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promptTextView.delegate = self
        itemOutlet.isHidden = true
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menu.target = self.revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
        //guard let string = descriptionString else {return}
        
        let string  = "cj test"
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
