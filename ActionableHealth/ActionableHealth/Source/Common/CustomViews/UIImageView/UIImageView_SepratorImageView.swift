//
//  UIImageView_SepratorImageView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class UIImageView_SepratorImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.getColorFromHexValue(0xDDE0E0, Alpha: 1)
    }
}
