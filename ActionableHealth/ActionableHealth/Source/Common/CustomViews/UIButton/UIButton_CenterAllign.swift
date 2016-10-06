//
//  UIButton_CenterAllign.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class UIButton_CenterAllign: UIButton_FontSizeButton {

    //MARK:- Init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.imageView?.contentMode = .Bottom
        self.titleLabel?.textAlignment = .Center
    }
}

//MARK:- Additional methods
extension UIButton_CenterAllign{

    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        super.imageRectForContentRect(contentRect)
        let width = contentRect.size.width/2
        let height = contentRect.size.height/2
        return CGRect(x: width/2, y: height/3, width: width, height: height * 0.8)
    }

    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        super.titleRectForContentRect(contentRect)
        let height = contentRect.size.height/2
        let y = 4*height/3 - 5
        return CGRect(x: contentRect.origin.x, y: y, width: contentRect.size.width, height: 20)
    }
}
