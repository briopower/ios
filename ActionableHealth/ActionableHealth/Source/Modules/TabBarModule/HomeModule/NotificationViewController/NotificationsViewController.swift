//
//  NotificationsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class NotificationsViewController: CommonViewController {

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("NOTIFICATIONS", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Cross)
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
}

//MARK:- Button Actions
extension NotificationsViewController{
    override func crossButtonAction(sender: UIButton?) {
        super.crossButtonAction(sender)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}