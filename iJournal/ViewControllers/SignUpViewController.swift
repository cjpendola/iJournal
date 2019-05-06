//
//  SignUpViewController.swift
//  Tiki
//
//  Created by Carlos Pendola on 4/3/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog
import JGProgressHUD
import MaterialComponents

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillHideNotification , object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillChangeFrameNotification , object: nil)
        
        usernameTextField.delegate  = self
        emailTextField.delegate     = self
        passwordTextField.delegate  = self
        password2TextField.delegate = self
    }
    
    @objc func keyboard(_ notification: Notification) {
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
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = password2TextField.text,
            let username = usernameTextField.text,
            !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !username.isEmpty else {
                self.showAlert(message: "We're missing something...")
                return
        }
       
        guard password == confirmPassword else {
            self.showAlert(message: "Password confirmation doesn't match.")
            return
        }
        
        self.view.endEditing(true)
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        FirebaseManager.shared.createUserAndProfileWith(username: username, email: email, password: password) { (success, shouldNotify, errorDescription) in
            hud.dismiss()
            if success {
                print("Successfully created user and profile.")
                self.performSegue(withIdentifier: "unwindToHomeWithSegue", sender: self)
            } else if shouldNotify, let description = errorDescription {
                self.showAlert(message: description)
                self.clearPasswordFields()
            } else {
                print("Failed to log in (no user notification for this specific error")
                self.showAlert(message: "Something went wrong...")
                self.clearPasswordFields()
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("loginButtonTapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginPage") as? LoginViewController {
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func clearPasswordFields(){
        passwordTextField.text = ""
        password2TextField.text = ""
    }
    
    func showAlert(message:String) {
        let title = "Alert!"
        let alert = MDCAlertController(title: title, message: message)
        alert.addAction(MDCAlertAction(title: "Ok", handler: nil))
        //MDCAlertControllerThemer.applyScheme(MDCAlertScheme(), to: alert)
        present(alert, animated: true, completion: nil)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
