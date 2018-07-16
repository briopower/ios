//
//  UIViewController_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit
enum BarButtontype {
    case empty, none, none2, back, search ,search_Notification, cross, done, details, add, skip, next
}

enum BarButtonPosition {
    case left,right
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
        return self as? UINavigationController ?? self.tabBarController?.navigationController ?? self.navigationController
    }
    func getNavigationItem() -> UINavigationItem? {

        if let tabbar = self.tabBarController{
            return tabbar.navigationItem
        }
        return self.navigationItem
    }

    func setNavigationBarBackgroundColor(_ color:UIColor?) -> Void {
        if let color = color {
            getNavigationController()?.navigationBar.setBackgroundImage(UIImage.getImageFromColor(color), for: UIBarMetrics.default)
            getNavigationController()?.view.backgroundColor = color
        }else{
            let color = UIColor.getColorFromHexValue(0xF5F5F5, Alpha: 0.9)
            getNavigationController()?.navigationBar.setBackgroundImage(UIImage.getImageFromColor(color), for: UIBarMetrics.default)
            getNavigationController()?.view.backgroundColor = color
        }
        getNavigationController()?.navigationBar.setNeedsDisplay()
    }

    func setNavigationBarWithTitleView(_ titleView:UIView, LeftButtonType leftButtonType:BarButtontype, RightButtonType rightButtonType:BarButtontype){
        getNavigationItem()?.titleView = titleView
        getNavigationItem()?.title = ""
        setBarButtonAt(.left, Type: leftButtonType)
        setBarButtonAt(.right, Type: rightButtonType)
    }

    func setNavigationBarWithTitle(_ title:String, LeftButtonType leftButtonType:BarButtontype, RightButtonType rightButtonType:BarButtontype){
        getNavigationItem()?.titleView = nil
        getNavigationController()?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.getAppThemeColor(),
            NSFontAttributeName: UIFont.getAppSemiboldFontWithSize(20)?.getDynamicSizeFont() ?? UIFont.systemFont(ofSize: 20).getDynamicSizeFont()]
        getNavigationItem()?.title = title
        setBarButtonAt(.left, Type: leftButtonType)
        setBarButtonAt(.right, Type: rightButtonType)
    }

    fileprivate func setBarButtonAt(_ position:BarButtonPosition, Type type:BarButtontype){
        var barButton:UIBarButtonItem?
        var barButton1:UIBarButtonItem?
        switch type {
        case .empty:
            barButton = nil
            barButton1 = nil
        case .none:
            barButton = UIBarButtonItem(customView:getButtonWithImage(NoneButtonImage,Action: #selector(self.noneButtonAction(_:))))
            barButton1 = nil
            getNavigationItem()?.backBarButtonItem = nil
        case .none2:
            barButton = UIBarButtonItem(customView:getButtonWithImage(NoneButtonImage,Action: #selector(self.noneButtonAction(_:))))
            barButton1 = UIBarButtonItem(customView:getButtonWithImage(NoneButtonImage,Action: #selector(self.noneButtonAction(_:))))
            getNavigationItem()?.backBarButtonItem = nil
        case .back:
            barButton = UIBarButtonItem(customView:getButtonWithImage(BackButtonImage,Action: #selector(self.backButtonAction(_:))))
        case .search:
            barButton = UIBarButtonItem(customView:getButtonWithImage(SearchButtonImage,Action: #selector(self.searchButtonAction(_:))))
        case .search_Notification:
            barButton = UIBarButtonItem(customView:getButtonWithImage(NotificationButtonImage,Action: #selector(self.notificationButtonAction(_:))))
            barButton1 = UIBarButtonItem(customView:getButtonWithImage(SearchButtonImage,Action: #selector(self.searchButtonAction(_:))))
        case .cross:
            barButton = UIBarButtonItem(customView:getButtonWithImage(CrossButtonImage,Action: #selector(self.crossButtonAction(_:))))
        case .done:
            barButton = UIBarButtonItem(customView:getButtonWithImage(DoneButtonImage,Action: #selector(self.doneButtonAction(_:))))
        case .details:
            barButton = UIBarButtonItem(customView:getButtonWithImage(DetailsButtonImage,Action: #selector(self.detailsButtonAction(_:))))
        case .add:
            barButton = UIBarButtonItem(customView:getButtonWithImage(AddButtonImage,Action: #selector(self.addButtonAction(_:))))
        case .skip:
            barButton = UIBarButtonItem(customView:getButtonWithTitle("Skip",Action: #selector(self.skipButtonAction(_:))))
        case .next:
            barButton = UIBarButtonItem(customView:getButtonWithTitle("Next",Action: #selector(self.nextButtonAction(_:))))
        }

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace , target: nil, action: nil)
        flexibleSpace.width = 16

        switch position {
        case .left:
            if barButton1 != nil {
                getNavigationItem()?.setLeftBarButtonItems([barButton!, flexibleSpace, barButton1!], animated: false)
            }else{
                getNavigationItem()?.setLeftBarButtonItems([barButton!], animated: false)
            }
        case .right:
            if barButton1 != nil {
                getNavigationItem()?.setRightBarButtonItems([barButton!, flexibleSpace, barButton1!], animated: false)
            }else{
                getNavigationItem()?.setRightBarButtonItems([barButton!], animated: false)
            }
        }
    }

    fileprivate func getButtonWithImage(_ image:UIImage?, Action action:Selector) -> UIButton{
        let button = UIButton(type:.custom)
        button.setImage(image, for: UIControlState())
        button.clipsToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setTitle("", for: UIControlState())
        button.sizeToFit()
        return button
    }
    fileprivate func getButtonWithTitle(_ title:String?, Action action:Selector) -> UIButton{
        let button = UIButton(type:.custom)
        button.clipsToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.getAppRegularFontWithSize(18)?.getDynamicSizeFont()
        button.setTitleColor(UIColor.getAppThemeColor(), for: UIControlState())
        button.setTitleColor(UIColor.getAppThemeColor().withAlphaComponent(0.2), for: .highlighted)
        button.sizeToFit()
        return button
    }
}

//MARK: Button Actions
extension UIViewController{
    @IBAction func noneButtonAction(_ sender:UIButton?){
    }
    @IBAction func backButtonAction(_ sender:UIButton?){
        UIApplication.dismissKeyboard()
        getNavigationController()?.popViewController(animated: true)
    }
    @IBAction func searchButtonAction(_ sender:UIButton?){
    }
    @IBAction func notificationButtonAction(_ sender:UIButton?){
    }
    @IBAction func crossButtonAction(_ sender:UIButton?){
    }
    @IBAction func doneButtonAction(_ sender:UIButton?){
        UIApplication.dismissKeyboard()
    }
    @IBAction func detailsButtonAction(_ sender:UIButton?){
        UIApplication.dismissKeyboard()
    }
    @IBAction func addButtonAction(_ sender:UIButton?){

    }
    @IBAction func skipButtonAction(_ sender:UIButton?){

    }
    @IBAction func nextButtonAction(_ sender:UIButton?){

    }
}

//MARK:- Additional methods
extension UIViewController{
    class func getTopMostViewController() -> UIViewController? {

        if let rootViewCont =  UIApplication.shared.keyWindow?.rootViewController{
            return self.getTopPresentedViewController(rootViewCont)
        }
        return nil
    }

    class func getTopPresentedViewController(_ viewControllerObj:UIViewController) -> UIViewController {

        if let presentedViewController = viewControllerObj.presentedViewController {
            return self.getTopPresentedViewController(presentedViewController)
        }else{
            return viewControllerObj
        }
    }

    class func presentLoginViewController(_ shouldResetData:Bool = false, animated:Bool = true, Completion complete:(()-> Void)? = nil){
        if let viewCont = getTopMostViewController() as? UINavigationController {
            if viewCont.viewControllers.count > 0{
                if let viewCont1 = UIStoryboard(name: Constants.Storyboard.LoginStoryboard.storyboardName, bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController {
                    viewCont.present(viewCont1, animated: animated, completion: {
                        if shouldResetData{
                            UserDefaults.clear()
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
