//
//  UISlider_Custom.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 03/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

@IBDesignable class UISlider_Custom: UISlider {

    //MARK:- Variables
    @IBInspectable var height: CGFloat = 8{
        didSet{
            self.layoutIfNeeded()
        }
    }

    //MARK:- overriden methods

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        super.trackRect(forBounds: bounds)
        return CGRect(origin: CGPoint(x: bounds.origin.x, y: (bounds.size.height - height)/2), size: CGSize(width: bounds.size.width, height: height))
    }

}
