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

    override func setTitle(_ title: String?, for state: UIControlState) {
        if isLocalized {
            super.setTitle(title?.localized, for: state)
        }else{
            super.setTitle(title, for: state)
        }
    }

    override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState) {
        if isLocalized{
            super.setAttributedTitle(title?.localized, for: state)
        }else{
            super.setAttributedTitle(title, for: state)
        }
    }

    func setup() {
        if isLocalized {
            super.setAttributedTitle(self.attributedTitle(for: self.state)?.localized, for: self.state)
            super.setTitle(title(for: self.state)?.localized, for: self.state)
        }else{
            super.setAttributedTitle(self.attributedTitle(for: self.state), for: self.state)
            super.setTitle(title(for: self.state), for: self.state)
        }
    }
}
