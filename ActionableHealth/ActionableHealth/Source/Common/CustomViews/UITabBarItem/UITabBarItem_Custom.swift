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
        self.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
       self.title = nil
    }

    func setImages() {
        if let type = TabBarType(rawValue: self.tag) {
            var normalImage:UIImage?
            var selectedStateImage:UIImage?
            switch type {
            case .Home:
                normalImage = UIImage(named: "Home-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Home-Yellow\(getImageNamePostFix())")
            case .Track:
                normalImage = UIImage(named: "Track-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Track-yellow\(getImageNamePostFix())")
            case .Chat:
                normalImage = UIImage(named: "Chat-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Chat-yellow\(getImageNamePostFix())")
            case .Group:
                normalImage = UIImage(named: "Group-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Group-yellow\(getImageNamePostFix())")
            case .Settings:
                normalImage = UIImage(named: "Setting-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Setting-yellow\(getImageNamePostFix())")
            }
            super.selectedImage = selectedStateImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            super.image = normalImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        }
    }

    func getImageNamePostFix() -> String {
        switch UIDevice.getDeviceType() {
        case .AppleIphone6P, .AppleIphone6SP, .AppleIphone7P:
            return "-3x.png"
        case .AppleIphone6S, .AppleIphone6, .AppleIphone7:
            return "-2x.png"
        case .Simulator:
            return "-3x.png"
        default:
            return "-1x.png"
        }
    }
}
