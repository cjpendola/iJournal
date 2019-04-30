//
//  CellCollectionViewCell.swift
//  iJournal
//
//  Created by Carlos Javier Pendola on 4/26/19.
//  Copyright © 2019 Carlos Javier Pendola. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    static var identifier: String = "Cell"
    
    weak var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        textLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        self.textLabel = textLabel
        self.reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset() {
        self.textLabel.textAlignment = .center
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
