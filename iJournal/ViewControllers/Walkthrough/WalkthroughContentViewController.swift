//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by Jonathan Tang on 15/03/2018.
//  Copyright © 2018 jtang0506. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
  
  // MARK: - Properties
  
    @IBOutlet weak var logoRiteTop: UIImageView!
    @IBOutlet var subHeadingLabel: UILabel! {
    didSet {
      subHeadingLabel.numberOfLines = 0
    }
  }
  
  @IBOutlet var contentImageView: UIImageView!
  
  var index = 0
  var subheading = ""
  var imageFile = ""
  
  // MARK: - View controller life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    subHeadingLabel.text = subheading
    contentImageView.image = UIImage(named: imageFile)
    
    view.backgroundColor = UIColor.clear
    view.isOpaque = false
    
    if(index == 0){
        self.logoRiteTop.isOpaque = true
        self.logoRiteTop.alpha = 0
    }
  }
  
}
