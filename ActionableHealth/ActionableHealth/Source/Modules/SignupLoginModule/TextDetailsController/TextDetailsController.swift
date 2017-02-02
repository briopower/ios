//
//  TextDetailsController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class TextDetailsController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet var titleView: UIImageView!

    //MARK:- LifeCycle
    override func viewDidLoad() {
        showLoginModule = false
        super.viewDidLoad()
        txtView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let width = (235/1242) * UIDevice.width()
        titleView.frame = CGRect(x: 0, y: 0, width: width, height:(75/235) * width)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Next)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        txtView.contentOffset = CGPointZero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Additional Methods
    override func nextButtonAction(sender: UIButton?) {
        super.nextButtonAction(sender)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.LoginStoryboard.verificationView) as? WelcomeToBrio {
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}
