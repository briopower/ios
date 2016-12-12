//
//  InviteForTrackCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum InviteForTrackCellType:Int{
    case RequestAdmin, CreateYourOwn, Count

    func getConfig(template:TemplatesModel?) -> (title:String, buttonTitle:String, image:UIImage?, descTitle:String?) {
        switch self {
        case .RequestAdmin:
            return ("Active Track", "Request Admin", UIImage(named: "logo-1"), "\(template?.activeTrackCount ?? 0)")
        case .CreateYourOwn:
            return ("You", "Create your own", UIImage(named: "circle-user-ic"), "1 User")
        default:
            return ("", "", nil, "")
        }
    }
}
protocol InviteForTrackCellDelegate:NSObjectProtocol {
    func actionButtonClicked(type:InviteForTrackCellType)
}
class InviteForTrackCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel_FontSizeLabel!
    @IBOutlet weak var actionButton: UIButton!

    //MARK:- Variables
    weak var delegate:InviteForTrackCellDelegate?
    var type = InviteForTrackCellType.RequestAdmin
    var currentTemplate:TemplatesModel?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK:- Additional methods
extension InviteForTrackCell{
    func configCell(cellType:InviteForTrackCellType, template:TemplatesModel?) {
        type = cellType
        currentTemplate = template
        let (title, buttonTitle, image, descTitle) = type.getConfig(currentTemplate)
        titleLabel.text = title
        actionButton.setTitle(buttonTitle, forState: .Normal)
        displayImageView.image = image
        descLabel.text = descTitle
    }

    @IBAction func actionButtonAction(sender: UIButton) {
        delegate?.actionButtonClicked(type)
    }
}
