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
    
    //MARK:- Variables
    var phoneDetail:NSMutableDictionary?
    
    //MARK:- ------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func textChanged(sender: AnyObject) {
        if let dict = phoneDetail{
                        dict["phone"] = phoneNoTxtFld.text
                    }
    }
    
}

//MARK:- Additional Functions
extension PhoneNoCell{
    func setUPCell(countryDict:NSDictionary? , phoneDict:NSMutableDictionary){
        phoneDetail = phoneDict
        if let dict = countryDict{
            countryCode.text = dict[normalizedISDCode_key] as? String ?? ""
        }
    }
    
    func textChanged(){
        
    }
}
