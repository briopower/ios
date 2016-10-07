//
//  CommonViewController_CommonMethods.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

enum BarButtontype {
    case Empty, None, Back, Search_Notification
}

enum BarButtonPosition {
    case Left,Right
}

import UIKit

let NoneButtonImage = UIImage(named: "noneButton")
let BackButtonImage = UIImage(named: "back")
let SearchButtonImage = UIImage(named: "search")
let NotificationButtonImage = UIImage(named: "notification")


//MARK: Navigation Controller Delegate
extension CommonViewController:UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool){
        if navigationController.childViewControllers.count > 1{
            navigationController.interactivePopGestureRecognizer?.enabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = self
        }else{
            navigationController.interactivePopGestureRecognizer?.enabled = false
            navigationController.interactivePopGestureRecognizer?.delegate = nil
        }
    }

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        self.dissmissKeyboard()
        viewController.view?.endEditing(true)
    }
}
//MARK: NavigationBar Setup
extension CommonViewController{

    func getNavigationController() -> UINavigationController? {
        if let tabbar = self.tabBarController{
            return tabbar.navigationController
        }
        return self.navigationController
    }
    func getNavigationItem() -> UINavigationItem? {

        if let tabbar = self.tabBarController{
            return tabbar.navigationItem
        }
        return self.navigationItem
    }
    
    func setNavigationBarBackgroundColor(color:UIColor?) -> Void {
        if color != nil {
            getNavigationController()?.navigationBar.setBackgroundImage(UIImage.getImageFromColor(color!), forBarMetrics: UIBarMetrics.Default)
        }else{
            getNavigationController()?.navigationBar.setBackgroundImage(UIImage.getImageFromColor(UIColor.getColorFromHexValue(0xF5F5F5, Alpha: 1)), forBarMetrics: UIBarMetrics.Default)
        }
        getNavigationController()?.navigationBar.setNeedsDisplay()
    }

    func setNavigationBarWithTitleView(titleView:UIView, LeftButtonType leftButtonType:BarButtontype, RightButtonType rightButtonType:BarButtontype){
        getNavigationItem()?.titleView = titleView
        getNavigationItem()?.title = ""
        setBarButtonAt(.Left, Type: leftButtonType)
        setBarButtonAt(.Right, Type: rightButtonType)
    }
    func setNavigationBarWithTitle(title:String, LeftButtonType leftButtonType:BarButtontype, RightButtonType rightButtonType:BarButtontype){
        getNavigationItem()?.titleView = nil
        getNavigationController()?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.getAppTextColor(),
            NSFontAttributeName: UIFont.getAppTitleFontWithSize(20)!.getDynamicSizeFont()]
        getNavigationItem()?.title = title
        setBarButtonAt(.Left, Type: leftButtonType)
        setBarButtonAt(.Right, Type: rightButtonType)
    }
    private func setBarButtonAt(position:BarButtonPosition, Type type:BarButtontype){
        var barButton:UIBarButtonItem?
        var barButton1:UIBarButtonItem?
        switch type {
        case .Empty:
            barButton = nil
            barButton1 = nil
        case .None:
            barButton = UIBarButtonItem(customView:getButtonWithImage(NoneButtonImage,Action: #selector(self.noneButtonAction(_:))))
            barButton1 = nil
            getNavigationItem()?.backBarButtonItem = nil
        case .Back:
            barButton = UIBarButtonItem(customView:getButtonWithImage(BackButtonImage,Action: #selector(self.backButtonAction(_:))))
        case .Search_Notification:
            barButton = UIBarButtonItem(customView:getButtonWithImage(NotificationButtonImage,Action: #selector(self.notificationButtonAction(_:))))
            barButton1 = UIBarButtonItem(customView:getButtonWithImage(SearchButtonImage,Action: #selector(self.searchButtonAction(_:))))
        }

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace , target: nil, action: nil)
        flexibleSpace.width = 16

        switch position {
        case .Left:
            if barButton1 != nil {
                getNavigationItem()?.setLeftBarButtonItems([barButton!, flexibleSpace, barButton1!], animated: false)
            }else{
                getNavigationItem()?.setLeftBarButtonItems([barButton!], animated: false)
            }
        case .Right:
            if barButton1 != nil {
                getNavigationItem()?.setRightBarButtonItems([barButton!, flexibleSpace, barButton1!], animated: false)
            }else{
                getNavigationItem()?.setRightBarButtonItems([barButton!], animated: false)
            }
        }
    }
    private func getButtonWithImage(image:UIImage?, Action action:Selector) -> UIButton{
        let button = UIButton(type:.Custom)
        button.setImage(image, forState: .Normal)
        button.clipsToBounds = true
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        button.setTitle("", forState: UIControlState.Normal)
        button.sizeToFit()
        return button
    }
    private func getButtonWithTitle(title:String?, Action action:Selector) -> UIButton{
        let button = UIButton(type:.Custom)
        button.clipsToBounds = true
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.getAppRegularFontWithSize(14.66)?.getDynamicSizeFont()
        button.setTitleColor(button.titleLabel?.textColor.colorWithAlphaComponent(0.2), forState: .Highlighted)
        button.sizeToFit()
        return button
    }
}

//MARK: Keyboard dismissal methods
extension CommonViewController{
    func dissmissKeyboard() {
        self.view.endEditing(true)
        UIApplication.sharedApplication().windows.first?.endEditing(true)
    }
}
//MARK:- Loader methods
extension CommonViewController{
    func showLoader() {
        if showLoading {
            VNProgreessHUD.showHUDAddedToView(self.view, Animated: true)
        }
    }

    func showLoaderOnWindow() {
        if let window = UIApplication.sharedApplication().keyWindow where showLoading {
            VNProgreessHUD.showHUDAddedToView(window, Animated: true)
        }
    }

    func hideLoader() {
        VNProgreessHUD.hideAllHudsFromView(self.view, Animated: true)
        if let window = UIApplication.sharedApplication().keyWindow {
            VNProgreessHUD.hideAllHudsFromView(window, Animated: true)
        }
    }
}

//MARK: NullCase Methods
extension CommonViewController:NullCaseDelegate{
    // Delegate has been implemented in class Because of issue in swift
    func showNullCase(view:UIView, type:NullCaseType, identifier:Int?, shouldPassTouch:Bool = false) {
        hideLoader()
        dissmissKeyboard()
        nullCaseView = NullCaseView.showNullCaseOn(view, nullCaseType: type, identifier: identifier, delegate: self, shouldPassTouch: shouldPassTouch)
    }

    func hideNullCase(view:UIView) {
        NullCaseView.hideNullCaseOn(view)
    }
}

//MARK: Button Actions
extension CommonViewController{
    @IBAction func noneButtonAction(sender:UIButton?){
    }
    @IBAction func backButtonAction(sender:UIButton?){
        self.dissmissKeyboard()
        getNavigationController()?.popViewControllerAnimated(true)
    }
    @IBAction func searchButtonAction(sender:UIButton?){
    }
    @IBAction func notificationButtonAction(sender:UIButton?){
    }
}

