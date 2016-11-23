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
    func configCell(template:TemplatesModel?, type:CollectionViewType) {
        currentTemplate = template

        switch type {
        case .HomeView:
            nameLabel.text = currentTemplate?.name
            templateImage.sd_setImageWithURL(NSURL(string: currentTemplate?.templateImageUrl ?? ""))
            ratingView.value = CGFloat(currentTemplate?.rating ?? 0)
        case .TrackView:
            nameLabel.text = currentTemplate?.name
            templateImage.sd_setImageWithURL(NSURL(string: currentTemplate?.trackImageUrl ?? ""))
            ratingView.value = CGFloat(currentTemplate?.rating ?? 0)
        default:
            break
        }
        
    }
}