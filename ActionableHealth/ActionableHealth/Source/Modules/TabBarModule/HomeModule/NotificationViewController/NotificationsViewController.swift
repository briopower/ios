//
//  NotificationsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class NotificationsViewController: CommonViewController {

    //MARK:- Variables
    var user = UserModel.getCurrentUser()
    var toggleSwitch:UISwitch?
    var previousState = false

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if getNavigationController()?.viewControllers.count ?? 0 > 1{
            self.setNavigationBarWithTitle("Notifications", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.Toggle)
        }else{
            self.setNavigationBarWithTitle("Notifications", LeftButtonType: BarButtontype.Cross, RightButtonType: BarButtontype.Toggle)
        }
        toggleSwitch = getNavigationItem()?.rightBarButtonItem?.customView as? UISwitch
        updateCurrentStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension NotificationsViewController{
    func setupView() {
        setNavigationBarBackgroundColor(UIColor.whiteColor())
    }

    func updateCurrentStatus() {
        user = UserModel.getCurrentUser()
        toggleSwitch?.on = user.enableNotifications
        previousState = user.enableNotifications
    }
}

//MARK:- Button Actions
extension NotificationsViewController{
    override func crossButtonAction(sender: UIButton?) {
        super.crossButtonAction(sender)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func toggleButtonAction(sender: UISwitch?) {
        super.toggleButtonAction(sender)
        user.enableNotifications = sender?.on ?? false
        updateProfile()
    }
}

//MARK:- Network Methods
extension NotificationsViewController{
    func updateProfile() {
        if NetworkClass.isConnected(true) {
            showLoaderOnWindow()
            NetworkClass.sendRequest(URL: Constants.URLs.updateMyProfile, RequestType: .POST, ResponseType: .JSON, Parameters: user.getUpdateProfileDictionary(), CompletionHandler: { (status, responseObj, error, statusCode) in
                if !status{
                    self.toggleSwitch?.on = self.previousState
                }else{
                    NSUserDefaults.saveUser(responseObj)
                    self.updateCurrentStatus()
                }
                self.hideLoader()
            })
        }
    }
}
