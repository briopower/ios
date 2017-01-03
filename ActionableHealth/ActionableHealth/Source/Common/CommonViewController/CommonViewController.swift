//
//  CommonViewController.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {
    //MARK:- variables
    var nullCaseView:NullCaseView?
    var showLoading = true
    var showLoginModule = true
    var imageView = UIImageView(frame: UIScreen.mainScreen().bounds)
    var loader:VNProgreessHUD?
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getNavigationController()?.delegate = self
        setNavigationBarBackgroundColor(UIColor.whiteColor())
        if !NSUserDefaults.isLoggedIn() && showLoginModule {
            imageView.image = UIImage.getLaunchImage()
            imageView.contentMode = .ScaleToFill
            imageView.backgroundColor = UIColor.whiteColor()
            UIApplication.sharedApplication().keyWindow?.addSubview(imageView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !NSUserDefaults.isLoggedIn() && showLoginModule {
            UIViewController.presentLoginViewController(true, animated: false, Completion: { 
                self.imageView.removeFromSuperview()
            })
        }
    }

    //MARK:  Delegate
    func retryButtonTapped(nullCaseType: NullCaseType, identifier: Int?) {

    }
}





