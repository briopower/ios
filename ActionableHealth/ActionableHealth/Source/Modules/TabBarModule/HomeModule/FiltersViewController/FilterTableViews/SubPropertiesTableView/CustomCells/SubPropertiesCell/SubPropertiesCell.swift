//
//  SubPropertiesCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class SubPropertiesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var subPropertyNameLabel: UILabel!

    //MARK:- Variables
    var currentSubProperty:SubProperties?

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
    func configureCell(subProperty:SubProperties) {
        currentSubProperty = subProperty
        subPropertyNameLabel.text = subProperty.name
        if subProperty.isSelected {
            checkBox.image = UIImage(named: "checkbox-selected")
        }else{
            checkBox.image = UIImage(named: "checkbox")
        }
    }
}
