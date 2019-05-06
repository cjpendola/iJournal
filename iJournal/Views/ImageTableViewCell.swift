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
            let img = content?.info as? UIImage
            batman.image = img
            //            batman.translatesAutoresizingMaskIntoConstraints = false
            //            batman.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            //            batman.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            //            batman.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            //            batman.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            //            batman.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            //            batman.contentMode = .scaleAspectFit
            //     batman.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 1)
            //            self.heightAnchor.constraint(equalToConstant: 330)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        guard let ratio = self.batman.image?.getAspectRatio() else {return}
        //        let height = (self.frame.width) / ratio
        //
        
    }
    
    
}
