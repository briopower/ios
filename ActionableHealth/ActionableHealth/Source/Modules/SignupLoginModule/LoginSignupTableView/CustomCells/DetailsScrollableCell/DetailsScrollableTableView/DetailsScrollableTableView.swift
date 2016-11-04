//
//  DetailsScrollableTableView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit


class DetailsScrollableTableView: UITableView {

    //MARK:- Variables
    var sourceType = LoginSignupTableViewSourceType.Login
    weak var currentUser:UserModel?

}

//MARK:- Additional methods
extension DetailsScrollableTableView{
    func setupTableView(sourceType:LoginSignupTableViewSourceType, user:UserModel?) {
        currentUser = user
        self.sourceType = sourceType
        self.delegate = self
        self.dataSource = self
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 100
        self.tableFooterView = UIView(frame: CGRectZero)
        registerCells()
        self.reloadData()
    }

    func registerCells() {
        self.registerNib(UINib.init(nibName: String(DetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(DetailsCell))
        self.registerNib(UINib.init(nibName: DetailsScrollableTableViewCellType.Password.forgotPasswordAddon(), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: DetailsScrollableTableViewCellType.Password.forgotPasswordAddon())
    }
}

//MARK:- UITableViewDataSource
extension DetailsScrollableTableView:UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sourceType {
        case .Login:
            return DetailsScrollableTableViewCellType.ConfirmPassword.rawValue
        case .Signup:
            return DetailsScrollableTableViewCellType.Count.rawValue
        case .ForgotPassword:
            return DetailsScrollableTableViewCellType.Password.rawValue
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let type = DetailsScrollableTableViewCellType(rawValue: indexPath.row) {
            if let cell = tableView.dequeueReusableCellWithIdentifier(String(DetailsCell)) as? DetailsCell {
                cell.configureCellForType(type, user: currentUser)
                switch type {
                case .Email, .ConfirmPassword:
                    return cell
                case .Phone:
                    if sourceType == LoginSignupTableViewSourceType.Login {
                        cell.configureCellForType(.Password, user: currentUser)
                    }
                    return cell
                case .Password:
                    if let newCell = tableView.dequeueReusableCellWithIdentifier(DetailsScrollableTableViewCellType.Password.forgotPasswordAddon()) as? DetailsCell where sourceType == LoginSignupTableViewSourceType.Login{
                        newCell.configureCellForType(type, user: currentUser)
                        return newCell
                    }else{
                        return cell
                    }
                default:
                    break
                }
            }
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension DetailsScrollableTableView:UITableViewDelegate{
    
}
