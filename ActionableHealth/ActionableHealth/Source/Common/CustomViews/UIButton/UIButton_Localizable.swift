//
//  UIButton_Localizable.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

@IBDesignable class UIButton_Localizable: UIButton {

    @IBInspectable var isLocalized:Bool = false{
        didSet{
            setup()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func setTitle(title: String?, forState state: UIControlState) {
        if isLocalized {
            super.setTitle(title?.localized, forState: state)
        }else{
            super.setTitle(title, forState: state)
        }
    }

    override func setAttributedTitle(title: NSAttributedString?, forState state: UIControlState) {
        if isLocalized{
            super.setAttributedTitle(title?.localized, forState: state)
        }else{
            super.setAttributedTitle(title, forState: state)
        }
    }

    func setup() {
        if isLocalized {
            super.setAttributedTitle(self.attributedTitleForState(self.state)?.localized, forState: self.state)
            super.setTitle(titleForState(self.state)?.localized, forState: self.state)
        }else{
            super.setAttributedTitle(self.attributedTitleForState(self.state), forState: self.state)
            super.setTitle(titleForState(self.state), forState: self.state)
        }
    }
}
