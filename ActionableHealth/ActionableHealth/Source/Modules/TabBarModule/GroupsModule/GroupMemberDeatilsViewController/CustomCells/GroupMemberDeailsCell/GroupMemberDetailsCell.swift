//
//  GroupMemberDetailsCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum GroupMemberDetailsCellType:Int {
    case Image, Name, Email, PhoneNumber, Company, Interest, Hobbies, Count

    func getTitleAndFont() -> (title:String, font:UIFont?) {
        switch self {
        case .Name:
            return ("NAME" , UIFont.getAppSemiboldFontWithSize(15)?.getDynamicSizeFont())
        case .Email:
            return ("EMAIL ADDRESS" , UIFont.getAppSemiboldFontWithSize(15)?.getDynamicSizeFont())
        case .PhoneNumber:
            return ("PHONE NUMBER" , UIFont.getAppSemiboldFontWithSize(15)?.getDynamicSizeFont())
        case .Company:
            return ("TITLE/COMPANY" , UIFont.getAppSemiboldFontWithSize(15)?.getDynamicSizeFont())
        case .Interest:
            return ("INTEREST" , UIFont.getAppRegularFontWithSize(15)?.getDynamicSizeFont())
        case .Hobbies:
            return ("HOBBIES" , UIFont.getAppRegularFontWithSize(15)?.getDynamicSizeFont())
        default:
            return ("", nil)
        }
    }
}
class GroupMemberDetailsCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK:- Additional methods
extension GroupMemberDetailsCell{
    func configureCellForType(type:GroupMemberDetailsCellType) {
        let (title, font) = type.getTitleAndFont()
        titleDescLabel.text = title
        contentLabel.font = font
    }
}