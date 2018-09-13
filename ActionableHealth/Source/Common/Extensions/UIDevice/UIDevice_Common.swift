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

    case unknownDevice = 0

    //Simulator
    case simulator

    //Apple TV
    case appleTV2G
    case appleTV3G
    case appleTV4G

    //Apple Watch
    case appleWatch
    case appleWatchSeries1
    case appleWatchSeries2

    //Apple iPad
    case appleIpad
    case appleIpad2
    case appleIpad3
    case appleIpad4
    case appleIpadAir
    case appleIpadAir2
    case appleIpadPro_12_9
    case appleIpadPro_9_7
    case appleIpadMini
    case appleIpadMini2
    case appleIpadMini3
    case appleIpadMini4

    //Apple iPhone
    case appleIphone
    case appleIphone3G
    case appleIphone3GS
    case appleIphone4
    case appleIphone4S
    case appleIphone5
    case appleIphone5C
    case appleIphone5S
    case appleIphone6
    case appleIphone6P
    case appleIphone6S
    case appleIphone6SP
    case appleIphoneSE
    case appleIphone7
    case appleIphone7P

    //Apple iPod touch
    case appleIpodTouch
    case appleIpodTouch2G
    case appleIpodTouch3G
    case appleIpodTouch4G
    case appleIpodTouch5G
    case appleIpodTouch6G
}

//MARK:- Additional methods
extension UIDevice{

    class func height() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    class func width() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    class func navigationBarheight() -> CGFloat {
        return 64
    }

    class func getDeviceType() -> DeviceType{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {

        //Simulator
        case "i386","x86_64": return .simulator
        //Apple TV
        case "AppleTV2,1": return .appleTV2G
        case "AppleTV3,1", "AppleTV3,2": return .appleTV3G
        case "AppleTV5,3": return .appleTV4G
        //Apple Watch
        case "Watch1,1", "Watch1,2": return .appleWatch
        case "Watch2,6", "Watch2,7": return .appleWatchSeries1
        case "Watch2,3", "Watch2,4": return .appleWatchSeries2

        //Apple iPad
        case "iPad1,1": return .appleIpad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .appleIpad2
        case "iPad3,1", "iPad3,2", "iPad3,3": return .appleIpad3
        case "iPad3,4", "iPad3,5", "iPad3,6": return .appleIpad4
        case "iPad4,1", "iPad4,2", "iPad4,3": return .appleIpadAir
        case "iPad5,3", "iPad5,4": return .appleIpadAir2
        case "iPad6,7", "iPad6,8": return .appleIpadPro_12_9
        case "iPad6,3", "iPad6,4": return .appleIpadPro_9_7
        case "iPad2,5", "iPad2,6", "iPad2,7": return .appleIpadMini
        case "iPad4,4", "iPad4,5", "iPad4,6": return .appleIpadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9": return .appleIpadMini3
        case "iPad5,1", "iPad5,2": return .appleIpadMini4

        //Apple iPhone
        case "iPhone1,1": return .appleIphone
        case "iPhone1,2": return .appleIphone3G
        case "iPhone2,1": return .appleIphone3GS
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .appleIphone4
        case "iPhone4,1": return .appleIphone4S
        case "iPhone5,1", "iPhone5,2": return .appleIphone5
        case "iPhone5,3", "iPhone5,4": return .appleIphone5C
        case "iPhone6,1", "iPhone6,2": return .appleIphone5S
        case "iPhone7,2": return .appleIphone6
        case "iPhone7,1": return .appleIphone6P
        case "iPhone8,1": return .appleIphone6S
        case "iPhone8,2": return .appleIphone6SP
        case "iPhone8,4": return .appleIphoneSE
        case "iPhone9,1", "iPhone9,3": return .appleIphone7
        case "iPhone9,2", "iPhone9,4": return .appleIphone7P

        //Apple iPod touch
        case "iPod1,1": return .appleIpodTouch
        case "iPod2,1": return .appleIpodTouch2G
        case "iPod3,1": return .appleIpodTouch3G
        case "iPod4,1": return .appleIpodTouch4G
        case "iPod5,1": return .appleIpodTouch5G
        case "iPod7,1": return .appleIpodTouch6G

        default:
            return .unknownDevice
        }
    }
}
