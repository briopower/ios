//
//  PhoneNoCell.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 06/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
protocol PhoneNoCellDelegate:NSObjectProtocol {
    func countryCodeTapped()
}
class PhoneNoCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var phoneNoTxtFld: UITextField!

    //MARK:- Variables
    weak var delegate:PhoneNoCellDelegate?
    var phoneDetail:NSMutableDictionary?

    //MARK:- ------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK:- Additional Functions
extension PhoneNoCell{
    func setUPCell(_ countryDict:NSDictionary? , phoneDict:NSMutableDictionary){
        phoneDetail = phoneDict
        if let dict = countryDict{
            countryCode.text = "+\(dict[normalizedISDCode_key] as? String ?? "")"
        }
    }

    @IBAction func countryCodeClicked(_ sender: UIButton) {
        delegate?.countryCodeTapped()
    }

    @IBAction func textChanged(_ sender: AnyObject) {
        if let dict = phoneDetail{
            dict["phone"] = phoneNoTxtFld.text
        }
        if let text = phoneNoTxtFld.text {
            if text.characters.count >= 10 {
                if let _ = ContactSyncManager.phoneNumberKit.parseMultiple([text]).first?.nationalNumber{
                    phoneNoTxtFld.resignFirstResponder()
                }
            }
        }
    }
}
