//
//  YearViewCell.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/30/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class YearViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                dateLabel!.textColor = UIColor.darkGray
            } else {
                dateLabel!.textColor = UIColor.lightGray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
