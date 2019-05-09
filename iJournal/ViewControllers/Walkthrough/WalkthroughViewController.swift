//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by Jonathan Tang on 16/03/2018.
//  Copyright © 2018 jtang0506. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    
    
    // MARK: - Properties
    @IBOutlet var pageControl: UIPageControl!
    
    
    
    @IBOutlet weak var signupButton: UIButton!{
        didSet {
            /*signupButton.layer.masksToBounds = true
            signupButton.layer.borderColor = UIColor.black.cgColor
            signupButton.layer.borderWidth = 1*/
        }
    }
    @IBOutlet weak var loginButton: UIButton!
        {
        didSet {
            /*loginButton.layer.masksToBounds = true
            loginButton.layer.borderColor = UIColor.black.cgColor
            loginButton.layer.borderWidth = 1*/
        }
    }
    
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    // MARK: - Action Methods
    @IBAction func signupButtonTapped(_ sender: Any) {
        print("signupButtonTapped")
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signUpViewController = storyboard.instantiateViewController(withIdentifier: "signupPage") as? SignUpViewController {
            //self.navigationController?.pushViewController(signUpViewController, animated: true)
            self.present(signUpViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("loginButtonTapped")
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginPage") as? LoginViewController {
            self.present(loginViewController, animated: true, completion: nil)
            //self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            pageControl.currentPage = index
        }
    }
}
