//
//  UIViewController_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit
enum BarButtontype {
    case Empty, None, Back, Search ,Search_Notification, Cross, Done, Details, Add, skip, Toggle
}

enum BarButtonPosition {
    case Left,Right
}

private let NoneButtonImage = UIImage(named: "noneButton")
private let BackButtonImage = UIImage(named: "back-btn")
private let SearchButtonImage = UIImage(named: "search")
private let NotificationButtonImage = UIImage(named: "notification")
private let CrossButtonImage = UIImage(named: "cut")
private let DoneButtonImage = UIImage(named: "tick")
private let DetailsButtonImage = UIImage(named: "action-button")
private let AddButtonImage = UIImage(named: "add-button")
private let DownloadButtonImage = UIImage(named: "add-button")

//MARK: NavigationBar Setup
extension UIViewController{

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
        if let color = color {
            getNavigationController()?.navigationBar.setBackgroundImage(UIImage.getImageFromColor(color), forBarMetrics: UIBarMetrics.Default)
            getNavigationController()?.view.backgroundColor = color
        }else{
            let color = UIColor.getColorFromHexValue(0xF5F5F5, Alpha: 1)
            getNavigationController()?.navigationBar.setBackgroundImage(UIImage.getImageFromColor(color), forBarMetrics: UIBarMetrics.Default)
            getNavigationController()?.view.backgroundColor = color
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
            NSForegroundColorAttributeName: UIColor.getAppThemeColor(),
            NSFontAttributeName: UIFont.getAppRegularFontWithSize(20)?.getDynamicSizeFont() ?? UIFont.systemFontOfSize(20).getDynamicSizeFont()]
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
        case .Search:
            barButton = UIBarButtonItem(customView:getButtonWithImage(SearchButtonImage,Action: #selector(self.searchButtonAction(_:))))
        case .Search_Notification:
            barButton = UIBarButtonItem(customView:getButtonWithImage(NotificationButtonImage,Action: #selector(self.notificationButtonAction(_:))))
            barButton1 = UIBarButtonItem(customView:getButtonWithImage(SearchButtonImage,Action: #selector(self.searchButtonAction(_:))))
        case .Cross:
            barButton = UIBarButtonItem(customView:getButtonWithImage(CrossButtonImage,Action: #selector(self.crossButtonAction(_:))))
        case .Done:
            barButton = UIBarButtonItem(customView:getButtonWithImage(DoneButtonImage,Action: #selector(self.doneButtonAction(_:))))
        case .Details:
            barButton = UIBarButtonItem(customView:getButtonWithImage(DetailsButtonImage,Action: #selector(self.detailsButtonAction(_:))))
        case .Add:
            barButton = UIBarButtonItem(customView:getButtonWithImage(AddButtonImage,Action: #selector(self.addButtonAction(_:))))
        case .skip:
            barButton = UIBarButtonItem(customView:getButtonWithTitle("SKIP",Action: #selector(self.skipButtonAction(_:))))
        case .Toggle:
            let toggleSwitch = UISwitch()
            toggleSwitch.addTarget(self, action: #selector(self.toggleButtonAction(_:)), forControlEvents: .ValueChanged)
            //            toggleSwitch.tintColor = UIColor.getAppThemeColor()
            toggleSwitch.onTintColor = UIColor.getAppThemeColor()
            barButton = UIBarButtonItem(customView:toggleSwitch)
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
        button.titleLabel?.font = UIFont.getAppRegularFontWithSize(18)?.getDynamicSizeFont()
        button.setTitleColor(UIColor.getAppThemeColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.getAppThemeColor().colorWithAlphaComponent(0.2), forState: .Highlighted)
        button.sizeToFit()
        return button
    }
}

//MARK: Button Actions
extension UIViewController{
    @IBAction func noneButtonAction(sender:UIButton?){
    }
    @IBAction func backButtonAction(sender:UIButton?){
        UIApplication.dismissKeyboard()
        getNavigationController()?.popViewControllerAnimated(true)
    }
    @IBAction func searchButtonAction(sender:UIButton?){
    }
    @IBAction func notificationButtonAction(sender:UIButton?){
    }
    @IBAction func crossButtonAction(sender:UIButton?){
    }
    @IBAction func doneButtonAction(sender:UIButton?){
        UIApplication.dismissKeyboard()
    }
    @IBAction func detailsButtonAction(sender:UIButton?){
        UIApplication.dismissKeyboard()
    }
    @IBAction func addButtonAction(sender:UIButton?){

    }
    @IBAction func skipButtonAction(sender:UIButton?){

    }
    @IBAction func toggleButtonAction(sender:UISwitch?){
        
    }
}

//MARK:- Additional methods
extension UIViewController{
    class func getTopMostViewController() -> UIViewController? {

        if let rootViewCont =  UIApplication.sharedApplication().keyWindow?.rootViewController{
            return self.getTopPresentedViewController(rootViewCont)
        }
        return nil
    }

    class func getTopPresentedViewController(viewControllerObj:UIViewController) -> UIViewController {

        if let presentedViewController = viewControllerObj.presentedViewController {
            return self.getTopPresentedViewController(presentedViewController)
        }else{
            return viewControllerObj
        }
    }

    class func presentLoginViewController(shouldResetData:Bool = false, animated:Bool = true, Completion complete:(()-> Void)? = nil){
        if let viewCont = getTopMostViewController() as? UINavigationController {
            if viewCont.viewControllers.count > 0{
                if let viewCont1 = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateInitialViewController() as? UINavigationController {
                    viewCont.presentViewController(viewCont1, animated: animated, completion: {
                        if shouldResetData{
                            NSUserDefaults.clear()
                            if let tabBarCont = viewCont.viewControllers[0] as? UITabBarController{
                                tabBarCont.selectedIndex = 0
                                if let homeView = tabBarCont.selectedViewController as?
                                    HomeViewController{
                                    homeView.reset()
                                }
                            }
                        }
                        complete?()
                    })
                }
            }
        }
    }
}
