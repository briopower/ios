//
//  UITextView_FontSizeTextView.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class UITextView_FontSizeTextView: UITextView_Localizable {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDynamicFontSize()
    }
}

//MARK:- Additional methods
extension UITextView_FontSizeTextView{
    func setDynamicFontSize() {
        if self.font != nil {
            self.font = self.font!.getDynamicSizeFont()
        }
    }
}
