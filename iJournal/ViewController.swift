//
//  ViewController.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/24/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        print("ViewController viewDidLoad")
        super.viewDidLoad()
        
        FirebaseManager.shared.addEntry { (success) in
            if(success){
                print("firebase")
            }
        }
        
        
        FirebaseManager.shared.getUserEntries { (success) in
            if(success){
                print("get firebase")
            }
        }
    }
    

}

