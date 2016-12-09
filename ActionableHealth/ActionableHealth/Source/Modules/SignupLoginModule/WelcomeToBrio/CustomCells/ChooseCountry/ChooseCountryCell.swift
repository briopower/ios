//
//  ChooseCountryCell.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 06/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class ChooseCountryCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var countryName: UITextField!
    
    //MARK:- ----------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Additional Functions
extension ChooseCountryCell{
    func setUpCell(countryDict:NSDictionary?){
        if let dict = countryDict{
            countryName.text = dict[countryName_key] as? String ?? ""            
        }
    }
}
