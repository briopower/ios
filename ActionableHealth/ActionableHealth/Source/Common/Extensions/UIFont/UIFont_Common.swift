//
//  UIFont_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

//MARK:- Instance methods
extension UIFont{
    func getDynamicSizeFont() -> UIFont {
        switch UIDevice.getDeviceType() {
        case .AppleIphone6P, .AppleIphone6SP, .AppleIphone7P:
            return self
        case .AppleIphone6S, .AppleIphone6, .AppleIphone7:
            return self.fontWithSize(self.pointSize * 0.91)
        case .Simulator:
            return self.fontWithSize(self.pointSize * 1)
        default:
            return self.fontWithSize(self.pointSize * 0.82)

        }
    }
}
//MARK: - Class methods
extension UIFont {

    class func printAvailableFonts(){
        for family in UIFont.familyNames() {
            print(family)
            for fontName in UIFont.fontNamesForFamilyName(family) {
                print(fontName)
            }
        }
    }

    class func getAppTitleFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "ProximaNovaSW07-Medium", size: size)
    }
    class func getAppRegularFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "ProximaNova-Regular", size: size)
    }
    class func getAppSemiboldFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "ProximaNova-Semibold", size: size)
    }
    
    class func getSizeWithFont(text : NSString, font : UIFont, constraintSize : CGSize) -> CGSize
    {
        return text.boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
    }
}
