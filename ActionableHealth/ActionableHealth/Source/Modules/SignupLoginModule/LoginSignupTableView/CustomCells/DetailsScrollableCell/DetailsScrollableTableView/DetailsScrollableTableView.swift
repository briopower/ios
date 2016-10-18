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
    var isLogin = false
    weak var currentUser:UserModel?

}

//MARK:- Additional methods
extension DetailsScrollableTableView{
    func setupTableView(isLogin:Bool, user:UserModel?) {
        currentUser = user
        self.isLogin = isLogin
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
        if !isLogin {
            return DetailsScrollableTableViewCellType.Count.rawValue
        }
        return DetailsScrollableTableViewCellType.ConfirmPassword.rawValue
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let type = DetailsScrollableTableViewCellType(rawValue: indexPath.row) {
            if let cell = tableView.dequeueReusableCellWithIdentifier(String(DetailsCell)) as? DetailsCell {
                cell.configureCellForType(type, user: currentUser)
                switch type {
                case .Email:
                    return cell
                case .Password:
                    if let newCell = tableView.dequeueReusableCellWithIdentifier(DetailsScrollableTableViewCellType.Password.forgotPasswordAddon()) as? DetailsCell where isLogin{
                        newCell.configureCellForType(type, user: currentUser)
                        return newCell
                    }else{
                        return cell
                    }
                case .ConfirmPassword:
                    return cell
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
