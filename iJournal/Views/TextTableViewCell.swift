//
//  TextTableViewCell.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/6/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
   
    var indexOfSelectedTextView: Int?
    var textChanged: ((String) -> Void)?
    
    var content: Element? {
        didSet{
            let string = content?.info as? String
            textView.text = string
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
        let temp = Element(info: textView.text as Any, file: .text)
        self.content?.info = temp.info
    }
}
