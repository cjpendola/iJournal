//
//  NSMutableAttributedString.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/4/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    func highlightTarget(target: String, color: UIColor) -> NSMutableAttributedString {
        let targetValue = String(target.dropFirst().dropLast())
        let regPattern = "\\[\(targetValue)\\]"
        if let regex = try? NSRegularExpression(pattern: regPattern, options: []) {
            let matchesArray = regex.matches(in: self.string, options: [], range: NSRange(location: 0, length: self.length))
            for match in matchesArray {
                let attributedText = NSMutableAttributedString(string: targetValue)
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: attributedText.length))
                self.replaceCharacters(in: match.range, with: attributedText)
            }
        }
        return self
    }
}

