//
//  UILabel_Localizable.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

@IBDesignable class UILabel_Localizable: UILabel {

    @IBInspectable var isLocalized:Bool = false{
        didSet{
            setup()
        }
    }

    override var text: String?{
        didSet{
            setup()
        }
    }

    override var attributedText: NSAttributedString?{
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

    func setup() {
        if isLocalized {
            super.attributedText = self.attributedText?.localized
            super.text = self.text?.localized
        }else{
            super.attributedText = self.attributedText
            super.text = self.text
        }
    }
}
