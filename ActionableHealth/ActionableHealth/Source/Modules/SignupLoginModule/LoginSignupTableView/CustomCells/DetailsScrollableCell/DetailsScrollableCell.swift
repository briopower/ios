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
    func configureCell(isLogin:Bool) {
        self.isLogin = isLogin
        tblView.setupTableView(isLogin)
    }
    class func getHeight(isLogin:Bool) -> CGFloat {
        let cellHeight = (195 * UIDevice.width()) / 1155
        if isLogin {
            return 2 * cellHeight
        }
        return 3 * cellHeight
    }
    
}