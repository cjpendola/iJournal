//
//  TutorialsTableViewCell.swift
//  MenuLateral_Final
//
//  Created by Luis Rollon Gordo on 6/10/16.
//  Copyright © 2016 EfectoApple. All rights reserved.
//

import UIKit

class TutorialsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView:UIImageView!
    @IBOutlet weak var authorImageView:UIImageView!
    @IBOutlet weak var postTitleLabel:UILabel!
    @IBOutlet weak var authorLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
