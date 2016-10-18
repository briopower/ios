//
//  LoginSignupTableView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum LoginSignupTableViewCellType:Int {
    case Logo, ScrollableContent, RequestButton, OrSeperator, GooglePlusSignIn, Count
}

protocol LoginSignupTableViewDelegate:NSObjectProtocol {
    func buttonPressed(type: ButtonCellType)
}
class LoginSignupTableView: TPKeyboardAvoidingTableView {

    //MARK:- Variables
    var isLogin = false
    weak var currentUser:UserModel?
    weak var loginSignupTblViewDelegate:LoginSignupTableViewDelegate?
    
}

//MARK:- Additional methods
extension LoginSignupTableView{
    func setupTableView(isLogin:Bool, user:UserModel) {
        currentUser = user
        self.isLogin = isLogin
        self.delegate = self
        self.dataSource = self
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 250
        self.tableFooterView = UIView(frame: CGRectZero)
        registerCells()
        self.reloadData()
    }

    func registerCells() {
        self.registerNib(UINib.init(nibName: String(LogoHeaderCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(LogoHeaderCell))
        self.registerNib(UINib.init(nibName: String(DetailsScrollableCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(DetailsScrollableCell))
        self.registerNib(UINib.init(nibName: ButtonCellType.Login.nibNameAndReuseIdentifier(), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: ButtonCellType.Login.nibNameAndReuseIdentifier())
        self.registerNib(UINib.init(nibName: ButtonCellType.OrSeprator.nibNameAndReuseIdentifier(), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: ButtonCellType.OrSeprator.nibNameAndReuseIdentifier())
        self.registerNib(UINib.init(nibName: ButtonCellType.GooglePlus.nibNameAndReuseIdentifier(), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: ButtonCellType.GooglePlus.nibNameAndReuseIdentifier())

    }
}

//MARK:- UITableViewDataSource
extension LoginSignupTableView:UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLogin {
            return LoginSignupTableViewCellType.Count.rawValue
        }
        return LoginSignupTableViewCellType.OrSeperator.rawValue
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let type = LoginSignupTableViewCellType(rawValue: indexPath.row) {
            switch type {
            case .Logo:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(LogoHeaderCell)) as? LogoHeaderCell {
                    return cell
                }
            case .ScrollableContent:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(DetailsScrollableCell)) as? DetailsScrollableCell {
                    cell.configureCell(isLogin, user: currentUser)
                    return cell
                }
            case .RequestButton:
                if let cell = tableView.dequeueReusableCellWithIdentifier(ButtonCellType.Login.nibNameAndReuseIdentifier()) as? ButtonCell {
                    if isLogin {
                        cell.configureForType(ButtonCellType.Login)
                    }else{
                        cell.configureForType(ButtonCellType.Signup)
                    }
                    cell.delegate = self
                    return cell
                }
            case .OrSeperator:
                if let cell = tableView.dequeueReusableCellWithIdentifier(ButtonCellType.OrSeprator.nibNameAndReuseIdentifier()) as? ButtonCell {
                    cell.configureForType(ButtonCellType.OrSeprator)
                    cell.delegate = self
                    return cell
                }
            case.GooglePlusSignIn:
                if let cell = tableView.dequeueReusableCellWithIdentifier(ButtonCellType.GooglePlus.nibNameAndReuseIdentifier()) as? ButtonCell {
                    cell.configureForType(ButtonCellType.GooglePlus)
                    cell.delegate = self
                    return cell
                }
            default:
                break
            }
        }
        return UITableViewCell()
    }
}

//MARK:- ButtonCellDelagte
extension LoginSignupTableView:ButtonCellDelegate{
    func buttonPressed(type: ButtonCellType) {
        loginSignupTblViewDelegate?.buttonPressed(type)
    }
}
//MARK:- UITableViewDelegate
extension LoginSignupTableView:UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let type = LoginSignupTableViewCellType(rawValue: indexPath.row) {
            switch type {
            case .ScrollableContent:
            return DetailsScrollableCell.getHeight(isLogin)
            default:
                break
            }
        }
        return UITableViewAutomaticDimension
    }
}
