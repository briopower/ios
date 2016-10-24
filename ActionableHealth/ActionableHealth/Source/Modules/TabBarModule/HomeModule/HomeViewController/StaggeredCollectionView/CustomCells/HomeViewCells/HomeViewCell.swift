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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var templateImage: UIImageView!

    //MARK:- Variables
    var currentTemplate:TemplatesModel?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addShadowToView(container)
    }

}

//MARK:- Additional methods
extension HomeViewCell{
    func configCell(template:TemplatesModel?) {
        currentTemplate = template
        nameLabel.text = currentTemplate?.name
        templateImage.sd_setImageWithURL(NSURL(string: currentTemplate?.imageUrl ?? ""))
    }
}