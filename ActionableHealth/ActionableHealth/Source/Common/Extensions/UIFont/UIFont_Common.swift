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
        case .AppleIphone6P, .AppleIphone6SP:
            return self
        case .AppleIphone6S, .AppleIphone6:
            return self.fontWithSize(self.pointSize * 0.91)
        case .Simulator:
            return self.fontWithSize(self.pointSize * 0.82)
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
        return UIFont(name: "BubbleboddyNeueTrial-Light", size: size)
    }
    class func getAppRegularFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Regular", size: size)
    }
    class func getAppSemiboldFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Semibold", size: size)
    }
    class func getAppThinFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Thin", size: size)
    }
    class func getAppUltralightFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Ultralight", size: size)
    }
    class func getAppBoldFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Bold", size: size)
    }
    class func getAppMediumFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Medium", size: size)
    }
    class func getAppHeavyFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Heavy", size: size)
    }
    class func getAppLightFontWithSize(size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Light", size: size)
    }
    
    class func getSizeWithFont(text : NSString, font : UIFont, constraintSize : CGSize) -> CGSize
    {
        return text.boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
    }
}
