//
//  PhoneNoCell.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 06/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class PhoneNoCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var phoneNoTxtFld: UITextField!
    
    
    //MARK:- ------------------
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
extension PhoneNoCell{
    func setUPCell(countryDict:NSDictionary?){
        if let dict = countryDict{
            countryCode.text = dict[normalizedISDCode_key] as? String ?? ""
        }
    }
}

//MARK:- Textfield Delegates
extension PhoneNoCell:UITextFieldDelegate{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        return true
    }
}
