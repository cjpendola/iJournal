//
//  HourPickerViewController.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/15/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class HourPickerViewController: UIViewController {

    @IBOutlet var hourPicker: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func savetimeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
