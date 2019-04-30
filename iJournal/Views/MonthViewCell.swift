//
//  MonthViewCell.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/30/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class MonthViewCell: UICollectionViewCell {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                monthLabel!.textColor = UIColor.green
                monthLabel.font = UIFont.boldSystemFont(ofSize: 14)
            } else {
                monthLabel!.textColor = UIColor.darkText
                monthLabel.font = UIFont.systemFont(ofSize: 14)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
