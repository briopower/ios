//
//  HomeViewCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class HomeViewCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet weak var container: UIView!

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addShadowToView(container)
    }

}
