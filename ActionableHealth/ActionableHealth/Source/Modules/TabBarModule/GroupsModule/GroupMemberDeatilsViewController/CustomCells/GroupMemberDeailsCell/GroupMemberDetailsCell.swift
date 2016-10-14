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

    func getTitle() -> String {
        switch self {
        case .Name:
            return "NAME"
        case .Email:
            return "EMAIL ADDRESS"
        case .PhoneNumber:
            return "PHONE NUMBER"
        case .Company:
            return "TITLE/COMPANY"
        case .Interest:
            return "INTEREST"
        case .Hobbies:
            return "HOBBIES"
        default:
            return ""
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
        titleDescLabel.text = type.getTitle()
    }
}