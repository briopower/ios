//
//  UITabBarItem_Custom.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 04/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum TabBarType:Int {
    case Home, Track, Chat, Group, Settings
}
class UITabBarItem_Custom: UITabBarItem {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setImages()
        self.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        self.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 15)
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage(named: "tabBarBG")
    }

    func setImages() {
        if let type = TabBarType(rawValue: self.tag) {
            var normalImage:UIImage?
            var selectedStateImage:UIImage?
            switch type {
            case .Home:
                normalImage = UIImage(named: "home\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "home_s\(getImageNamePostFix())")
            case .Track:
                normalImage = UIImage(named: "Track\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Track_s\(getImageNamePostFix())")
            case .Chat:
                normalImage = UIImage(named: "chat\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "chat_s\(getImageNamePostFix())")
            case .Group:
                normalImage = UIImage(named: "group\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "group_s\(getImageNamePostFix())")
            case .Settings:
                normalImage = UIImage(named: "settings\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "settings_s\(getImageNamePostFix())")
            }
            super.selectedImage = selectedStateImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            super.image = normalImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        }
    }

    func getImageNamePostFix() -> String {
        switch UIDevice.getDeviceType() {
        case .AppleIphone6P, .AppleIphone6SP, .AppleIphone7P:
            return "_3x.png"
        case .AppleIphone6S, .AppleIphone6, .AppleIphone7:
            return "_x.png"
        case .Simulator:
            return "_x.png"
        default:
            return "_2x.png"
        }
    }
}
