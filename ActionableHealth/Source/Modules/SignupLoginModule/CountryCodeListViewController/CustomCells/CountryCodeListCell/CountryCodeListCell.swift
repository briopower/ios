//
//  CountryCodeListCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class CountryCodeListCell: UITableViewCell {

    @IBOutlet weak var majorLable: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Additional methods
extension CountryCodeListCell{
    func configCell(_ dict:NSDictionary) {
        majorLable.text = dict[countryName_key] as? String
        minorLabel.text = "+\(dict[normalizedISDCode_key] as? String ?? ""), \(dict[countryCode_key] as? String ?? "")"
    }
}
