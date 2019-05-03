//
//  preHomeViewController.swift
//  Tiki
//
//  Created by Carlos Pendola on 4/4/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class preHomeViewController: UIViewController {
    
    var listenerHandle: AuthStateDidChangeListenerHandle?
    
    var profile: UserProfile?
    
    override func viewDidLoad() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        listenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("User is logged in.")
                FirebaseManager.shared.fetchLoggedInUserProfile(completion: { (success) in
                    if success {
                        print("Successfully fetched user profile")
                        self.gotoUserHome()
                    } else {
                        print("There was an issue fetching user profile")
                    }
                })
                return
            }
            print("No user currently logged in. Onboarding!!!")
            FirebaseManager.shared.loggedInUserProfile = nil
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
                self.present(walkthroughViewController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let listenerHandle = listenerHandle else {
            print("Sign in state listener handle was nil. Unable to remove.")
            return
        }
        Auth.auth().removeStateDidChangeListener(listenerHandle)
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
        if(FirebaseManager.shared.loggedInUserProfile != nil){
            gotoUserHome()
        }
    }
    
    func gotoUserHome(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "home")
        self.present(controller, animated: true, completion: nil)
    }
}
