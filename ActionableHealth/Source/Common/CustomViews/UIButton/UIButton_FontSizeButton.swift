//
//  UIButton_FontSizeButton.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class UIButton_FontSizeButton: UIButton_Localizable {

    //MARK:- Init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDynamicFontSize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

//MARK:- Additional methods
extension UIButton_FontSizeButton{

    func setDynamicFontSize() {
        self.titleLabel?.font = self.titleLabel?.font.getDynamicSizeFont()
    }
}
