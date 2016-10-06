//
//  UIButton_RoundButton.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class UIButton_RoundButton: UIButton_FontSizeButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
