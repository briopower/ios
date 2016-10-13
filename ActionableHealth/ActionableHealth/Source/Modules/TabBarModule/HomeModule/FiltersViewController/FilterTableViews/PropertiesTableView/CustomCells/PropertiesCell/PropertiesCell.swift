//
//  PropertiesCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class PropertiesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var bgSelectedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    //MARK:- Variables
    var currentProperty:Properties?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK:- Additional methods
    func configureCell(property:Properties) {
        currentProperty = property
        nameLabel.text = property.name
        countLabel.text = property.selectedItemsCount > 0 ? "\(property.selectedItemsCount)": ""
        setupForSelectedState(property.isSelected)
    }

    func setupForSelectedState(isSelcted:Bool) {
        if isSelcted {
            bgSelectedImageView.backgroundColor = UIColor.getAppThemeColor()
            nameLabel.textColor = UIColor.whiteColor()
            countLabel.textColor = UIColor.whiteColor()
        }else{
            bgSelectedImageView.backgroundColor = UIColor.clearColor()
            nameLabel.textColor = UIColor.getAppTextColor()
            countLabel.textColor = UIColor.getAppTextColor()
        }
    }
}
