//
//  UILabel_FontSizeLabel.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//


import UIKit

class UILabel_FontSizeLabel: UILabel_Localizable {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDynamicFontSize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDynamicFontSize()
    }
}

//MARK:- Additional methods
extension UILabel_FontSizeLabel{
    func setDynamicFontSize() {
        self.font = self.font.getDynamicSizeFont()
    }
}
