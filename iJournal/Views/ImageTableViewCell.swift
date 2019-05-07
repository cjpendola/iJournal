//
//  ImageTableViewCell.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 5/6/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

class ImageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var batman: UIImageView!
    var content: Element?{
        didSet{
            if let img = content?.info as? UIImage{
                batman.image = img
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
