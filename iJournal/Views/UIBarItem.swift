//
//  UIBarItem.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/8/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import Foundation

public extension UIBarButtonItem {
    @IBInspectable var accEnabled: Bool {
        get {
            return isAccessibilityElement
        }
        set {
            isAccessibilityElement = newValue
        }
    }
    
    @IBInspectable var accLabelText: String? {
        get {
            return accessibilityLabel
        }
        set {
            accessibilityLabel = newValue
        }
    }
    
    var isHidden: Bool {
        get {
            return tintColor == UIColor.clear
        }
        set(hide) {
            if hide {
                isEnabled = false
                tintColor = UIColor.clear
            } else {
                isEnabled = true
                tintColor = nil // This sets the tinColor back to the default. If you have a custom color, use that instead
            }
        }
    }
}
