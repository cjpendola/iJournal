//
//  MenuViewController.swift
//  MenuLateral_Final
//
//  Created by Luis Rollon Gordo on 6/10/16.
//  Copyright © 2016 EfectoApple. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var exportLabel: UILabel!
    @IBOutlet weak var archiveLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showHomeMenu), name: Notification.Name("showHomeMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showArchiveMenu), name: Notification.Name("showArchiveMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSettingsMenu), name: Notification.Name("showSettingsMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showExportMenu), name: Notification.Name("showExportMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showTagsMenu), name: Notification.Name("showTagsMenu"), object: nil)
    }
    
    @objc func showHomeMenu(){
        returnLabelsColor()
        homeLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    @objc func showArchiveMenu(){
        returnLabelsColor()
        archiveLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    @objc func showSettingsMenu(){
        returnLabelsColor()
        settingsLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    @objc func showExportMenu(){
        returnLabelsColor()
        exportLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    @objc func showTagsMenu(){
        returnLabelsColor()
        tagsLabel.textColor = UIColor(red:1, green:0.4, blue:0.32, alpha:1)
    }
    
    func returnLabelsColor(){
        homeLabel.textColor     = UIColor.white
        tagsLabel.textColor     = UIColor.white
        exportLabel.textColor   = UIColor.white
        archiveLabel.textColor  = UIColor.white
        settingsLabel.textColor = UIColor.white
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        FirebaseManager.shared.signOut { (success) in
            if (success == nil) {
                self.performSegue(withIdentifier: "unwindToHomeWithSegue", sender: self)
            }
        }
    }
}
