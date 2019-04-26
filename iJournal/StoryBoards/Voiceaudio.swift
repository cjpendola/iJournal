//
//  Voiceaudio.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/26/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class Voiceaudio: UIView {
    let kCONTENT_XIB_NAME = "Voiceaudio"
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
    }
}
