//
//  UITabBarItem_Custom.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 04/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class UITabBarItem_Custom: UITabBarItem {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.selectedImage = self.selectedImage?.resizeImage(UIDevice.width()/3, newHeight: 50).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        super.image = self.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        self.imageInsets = UIEdgeInsets(top: 5.5, left: 0, bottom: -5.5, right: 0)
    }
}
