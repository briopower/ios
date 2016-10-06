//
//  UITextField_FontSizeTextField.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class UITextField_FontSizeTextField: UITextField_Localizable {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDynamicFontSize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

//MARK:- Additional methods
extension UITextField_FontSizeTextField{
    func setDynamicFontSize() {
        if self.font != nil {
            self.font = self.font!.getDynamicSizeFont()
        }
    }
}
