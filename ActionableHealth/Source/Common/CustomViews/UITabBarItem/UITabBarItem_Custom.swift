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
                normalImage = UIImage(named: "Home-white")
                selectedStateImage = UIImage(named: "Home-Yellow")
            case .track:
                normalImage = UIImage(named: "Track-white")
                selectedStateImage = UIImage(named: "Track-yellow")
            case .chat:
                normalImage = UIImage(named: "Chat-white")
                selectedStateImage = UIImage(named: "Chat-yellow")
            case .settings:
                normalImage = UIImage(named: "Setting-white")
                selectedStateImage = UIImage(named: "Setting-yellow")
            }
            super.selectedImage = selectedStateImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
            super.image = normalImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        }
    }
}
