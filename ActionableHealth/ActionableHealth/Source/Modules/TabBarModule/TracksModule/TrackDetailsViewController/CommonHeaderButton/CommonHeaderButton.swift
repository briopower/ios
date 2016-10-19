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


    override var selected: Bool {
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

        self.setTitleColor(UIColor.getAppThemeColor(), forState: UIControlState.Selected)
        bottomImage = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height-2, width: self.frame.size.width, height: 1.5))
        bottomImage.backgroundColor = UIColor.getAppThemeColor()
       bottomImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bottomImage)
        
        self.addConstraint(NSLayoutConstraint(item: bottomImage, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: bottomImage, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: bottomImage, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
        bottomImage.addConstraint(NSLayoutConstraint(item: bottomImage, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 2))

        
    }


}
