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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if getNavigationController()?.viewControllers.count ?? 0 > 1{
            self.setNavigationBarWithTitle("Notifications", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        }else{
            self.setNavigationBarWithTitle("Notifications", LeftButtonType: BarButtontype.none, RightButtonType: BarButtontype.cross)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension NotificationsViewController{
    func setupView() {
    }
}

//MARK:- Button Actions
extension NotificationsViewController{
    override func crossButtonAction(_ sender: UIButton?) {
        super.crossButtonAction(sender)
        self.dismiss(animated: true, completion: nil)
    }
}


