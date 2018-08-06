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
    @IBOutlet weak var logoImageView: UIImageView!

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
    func configCell(_ template:TemplatesModel?, type:CollectionViewType) {
        currentTemplate = template
        ratingView.value = CGFloat(currentTemplate?.rating ?? 0)

        switch type {
        case .templateView:
            nameLabel.text = currentTemplate?.name
            logoImageView.image = UIImage(named: "logo-1")
            templateImage.sd_setImage(with: URL(string: currentTemplate?.templateImageUrl ?? ""))
        case .trackView:
            nameLabel.text = currentTemplate?.name
            templateImage.sd_setImage(with: URL(string: currentTemplate?.trackImageUrl ?? ""))
            logoImageView.sd_setImage(with: URL(string: currentTemplate?.templateImageUrl ?? ""))
        default:
            break
        }
        
    }
}
