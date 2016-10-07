//
//  UIDevice_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

enum DeviceType: Int {

    //Apple UnknownDevices

    case UnknownDevice = 0

    //Simulator
    case Simulator

    //Apple TV
    case AppleTV2G
    case AppleTV3G
    case AppleTV4G

    //Apple Watch
    case AppleWatch
    case AppleWatchSeries1
    case AppleWatchSeries2

    //Apple iPad
    case AppleIpad
    case AppleIpad2
    case AppleIpad3
    case AppleIpad4
    case AppleIpadAir
    case AppleIpadAir2
    case AppleIpadPro_12_9
    case AppleIpadPro_9_7
    case AppleIpadMini
    case AppleIpadMini2
    case AppleIpadMini3
    case AppleIpadMini4

    //Apple iPhone
    case AppleIphone
    case AppleIphone3G
    case AppleIphone3GS
    case AppleIphone4
    case AppleIphone4S
    case AppleIphone5
    case AppleIphone5C
    case AppleIphone5S
    case AppleIphone6
    case AppleIphone6P
    case AppleIphone6S
    case AppleIphone6SP
    case AppleIphoneSE
    case AppleIphone7
    case AppleIphone7P

    //Apple iPod touch
    case AppleIpodTouch
    case AppleIpodTouch2G
    case AppleIpodTouch3G
    case AppleIpodTouch4G
    case AppleIpodTouch5G
    case AppleIpodTouch6G
}

//MARK:- Additional methods
extension UIDevice{

    class func height() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }

    class func width() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }

    class func getDeviceType() -> DeviceType{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {

        //Simulator
        case "i386","x86_64": return .Simulator
        //Apple TV
        case "AppleTV2,1": return .AppleTV2G
        case "AppleTV3,1", "AppleTV3,2": return .AppleTV3G
        case "AppleTV5,3": return .AppleTV4G
        //Apple Watch
        case "Watch1,1", "Watch1,2": return .AppleWatch
        case "Watch2,6", "Watch2,7": return .AppleWatchSeries1
        case "Watch2,3", "Watch2,4": return .AppleWatchSeries2

        //Apple iPad
        case "iPad1,1": return .AppleIpad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .AppleIpad2
        case "iPad3,1", "iPad3,2", "iPad3,3": return .AppleIpad3
        case "iPad3,4", "iPad3,5", "iPad3,6": return .AppleIpad4
        case "iPad4,1", "iPad4,2", "iPad4,3": return .AppleIpadAir
        case "iPad5,3", "iPad5,4": return .AppleIpadAir2
        case "iPad6,7", "iPad6,8": return .AppleIpadPro_12_9
        case "iPad6,3", "iPad6,4": return .AppleIpadPro_9_7
        case "iPad2,5", "iPad2,6", "iPad2,7": return .AppleIpadMini
        case "iPad4,4", "iPad4,5", "iPad4,6": return .AppleIpadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9": return .AppleIpadMini3
        case "iPad5,1", "iPad5,2": return .AppleIpadMini4

        //Apple iPhone
        case "iPhone1,1": return .AppleIphone
        case "iPhone1,2": return .AppleIphone3G
        case "iPhone2,1": return .AppleIphone3GS
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .AppleIphone4
        case "iPhone4,1": return .AppleIphone4S
        case "iPhone5,1", "iPhone5,2": return .AppleIphone5
        case "iPhone5,3", "iPhone5,4": return .AppleIphone5C
        case "iPhone6,1", "iPhone6,2": return .AppleIphone5S
        case "iPhone7,2": return .AppleIphone6
        case "iPhone7,1": return .AppleIphone6P
        case "iPhone8,1": return .AppleIphone6S
        case "iPhone8,2": return .AppleIphone6SP
        case "iPhone8,4": return .AppleIphoneSE
        case "iPhone9,1", "iPhone9,3": return .AppleIphone7
        case "iPhone9,2", "iPhone9,4": return .AppleIphone7P

        //Apple iPod touch
        case "iPod1,1": return .AppleIpodTouch
        case "iPod2,1": return .AppleIpodTouch2G
        case "iPod3,1": return .AppleIpodTouch3G
        case "iPod4,1": return .AppleIpodTouch4G
        case "iPod5,1": return .AppleIpodTouch5G
        case "iPod7,1": return .AppleIpodTouch6G

        default:
            return .UnknownDevice
        }
    }
}
