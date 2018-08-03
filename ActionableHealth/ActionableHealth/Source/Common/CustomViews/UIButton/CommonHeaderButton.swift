//
//  CommonHeaderButton.swift
//  Petcomm
//
//  Created by Raushan Kumar on 26/05/16.
//  Copyright © 2016 Freshworks. All rights reserved.
//

import UIKit

class CommonHeaderButton: UIButton_FontSizeButton {

    var bottomImage = UIImageView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    override var isSelected: Bool {
        willSet {
            if newValue
            {
                bottomImage.backgroundColor = UIColor.getAppThemeColor()
            }
            else
            {
                bottomImage.backgroundColor = UIColor.getAppSeperatorColor()
            }
        }
    }

    override func awakeFromNib() {

        self.setTitleColor(UIColor.getAppThemeColor(), for: UIControlState.selected)
        bottomImage = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height-2, width: self.frame.size.width, height: 1.5))
        bottomImage.backgroundColor = UIColor.getAppThemeColor()
        bottomImage.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(bottomImage)

        self.addConstraint(NSLayoutConstraint(item: bottomImage, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))

        self.addConstraint(NSLayoutConstraint(item: bottomImage, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0))

        self.addConstraint(NSLayoutConstraint(item: bottomImage, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0))

        bottomImage.addConstraint(NSLayoutConstraint(item: bottomImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2))
        
    }
}
