//
//  UIColor_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

//MARK:- Additional methods
extension UIColor{
    
    class func getColorFromHexValue(hexValue:UInt64,Alpha alpha:Float)-> UIColor{
        return UIColor.init(colorLiteralRed: ((Float)((hexValue & 0xFF0000) >> 16))/255.0, green: ((Float)((hexValue & 0xFF00) >> 8))/255.0, blue: ((Float)(hexValue & 0xFF))/255.0, alpha: alpha)
    }
    
    class func getAppTextColor() -> UIColor{
        return self.getColorFromHexValue(0x464646, Alpha: 1)
    }
    
    class func getAppThemeColor() -> UIColor{
        return self.getColorFromHexValue(0x1587CC, Alpha: 1)
    }

    class func getAppSeperatorColor() -> UIColor {
        return self.getColorFromHexValue(0xDDE0E0, Alpha: 1)
    }
}
