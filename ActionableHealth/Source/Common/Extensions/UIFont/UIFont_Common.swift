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
        case .appleIphone6P, .appleIphone6SP, .appleIphone7P:
            return self
        case .appleIphone6S, .appleIphone6, .appleIphone7:
            return self.withSize(self.pointSize * 0.91)
        case .simulator:
            return self.withSize(self.pointSize * 0.85)
        default:
            return self.withSize(self.pointSize * 0.85)

        }
    }
}
//MARK: - Class methods
extension UIFont {

    class func printAvailableFonts(){
        for family in UIFont.familyNames {
            debugPrint(family)
            for fontName in UIFont.fontNames(forFamilyName: family) {
                debugPrint(fontName)
            }
        }
    }

    class func getAppTitleFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "ProximaNovaSW07-Medium", size: size)
    }
    class func getAppRegularFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "ProximaNova-Regular", size: size)
    }
    class func getAppSemiboldFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "ProximaNova-Semibold", size: size)
    }
    
    class func getSizeWithFont(_ text : NSString, font : UIFont, constraintSize : CGSize) -> CGSize
    {
        return text.boundingRect(with: constraintSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).size
    }
}
