//
//  DetailsScrollableCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class DetailsScrollableCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var tblView: DetailsScrollableTableView!
    @IBOutlet weak var tblViewContainer: UIView!

    //MARK:- Variables
    var isLogin = false
    weak var currentUser:UserModel?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonMethods.addShadowToView(tblViewContainer)
        CommonMethods.setCornerRadius(tblView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Additional methods
extension DetailsScrollableCell{
    func configureCell(isLogin:Bool, user:UserModel?) {
        currentUser = user
        self.isLogin = isLogin
        tblView.setupTableView(isLogin, user: currentUser)
    }
    class func getHeight(isLogin:Bool) -> CGFloat {
        let cellHeight = (195 * UIDevice.width()) / 1155
        if isLogin {
            return 2 * cellHeight
        }
        return 3 * cellHeight
    }
    
}