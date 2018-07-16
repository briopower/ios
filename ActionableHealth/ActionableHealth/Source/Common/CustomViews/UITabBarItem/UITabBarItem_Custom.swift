//
//  UITabBarItem_Custom.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 04/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum TabBarType:Int {
    case home, track, chat, settings
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
            case .home:
                normalImage = UIImage(named: "Home-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Home-Yellow\(getImageNamePostFix())")
            case .track:
                normalImage = UIImage(named: "Track-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Track-yellow\(getImageNamePostFix())")
            case .chat:
                normalImage = UIImage(named: "Chat-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Chat-yellow\(getImageNamePostFix())")
            case .settings:
                normalImage = UIImage(named: "Setting-white\(getImageNamePostFix())")
                selectedStateImage = UIImage(named: "Setting-yellow\(getImageNamePostFix())")
            }
            super.selectedImage = selectedStateImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
            super.image = normalImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        }
    }

    func getImageNamePostFix() -> String {
        switch UIDevice.getDeviceType() {
        case .appleIphone6P, .appleIphone6SP, .appleIphone7P:
            return "-3x.png"
        case .appleIphone6S, .appleIphone6, .appleIphone7:
            return "-2x.png"
        case .simulator:
            return "-1x.png"
        default:
            return "-1x.png"
        }
    }
}
