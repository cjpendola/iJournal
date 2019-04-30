//
//  YearViewCell.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/30/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                dateLabel!.textColor = UIColor.green
                dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
            } else {
                dateLabel!.textColor = UIColor.darkText
                dateLabel.font = UIFont.systemFont(ofSize: 14)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
