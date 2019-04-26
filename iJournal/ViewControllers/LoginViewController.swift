//
//  LoginViewController.swift
//  Tiki
//
//  Created by Carlos Pendola on 3/31/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog
import JGProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToList = "LoginUser"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillHideNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillChangeFrameNotification , object: nil)

        self.textFieldLoginEmail.delegate = self
        self.textFieldLoginPassword.delegate = self
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    @objc
    func keyboard(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[ UIResponder.keyboardFrameBeginUserInfoKey ] as! NSValue).cgRectValue
        let keyboardViewEndFrame =  view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            self.scrollView?.contentInset = UIEdgeInsets.zero
            scrollView.contentOffset.y = 0
        }else{
            self.scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            scrollView.contentOffset.y = keyboardViewEndFrame.height - 50
        }
        
        scrollView?.scrollIndicatorInsets = scrollView.contentInset
        
    }

    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        guard
            let email = textFieldLoginEmail.text,
            let password = textFieldLoginPassword.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        self.view.endEditing(true)
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
       
        FirebaseManager.shared.signInWith(email: email, password: password) { (success, shouldNotify, errorDescription) in
            hud.dismiss()
            if success {
                print("Successfully logged in")
                self.performSegue(withIdentifier: "unwindToHomeWithSegue", sender: self)
            } else if shouldNotify, let description = errorDescription {
                print("Unable to log in.")
                self.textFieldLoginPassword.text = ""
                self.showAlert(message: description)
            } else {
                print("Unable to log in (no user feedback for this error)")
                self.textFieldLoginPassword.text = ""
                self.showAlert(message: "Something went wrong...Try again")
            }
        }
        
    }
    
    func showAlert(message:String) {
        let title = "Alert!"
        let message = message
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: false) {}
        let buttonOne = DefaultButton(title: "Ok") {
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
}
