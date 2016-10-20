//
//  HomeViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class HomeViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var clctView: StaggeredCollectionView!


    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("HOME", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Search_Notification)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension HomeViewController{
    func setupView() {
        CommonMethods.addShadowToTabBar(self.tabBarController?.tabBar)
        setNavigationBarBackgroundColor(UIColor.whiteColor())
        CommonMethods.addShadowToView(buttonsContainer)
        var index = 0
        var imageNameList : Array <NSString> = []
        while(index<14){
            let imageName = NSString(format: "%d.jpg", index)
            imageNameList.append(imageName)
            index += 1
        }
        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray(array: imageNameList)
        clctView.type = CollectionViewType.HomeView
        clctView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
}
//MARK:- CommonCollectionViewDelegate
extension HomeViewController:CommonCollectionViewDelegate{
    func topElements(view: UIView) {

    }

    func bottomElements(view: UIView) {

    }

    func clickedAtIndexPath(indexPath: NSIndexPath, object: AnyObject) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackDetailsView) as? TrackDetailsViewController {
            dispatch_async(dispatch_get_main_queue(), {
                viewCont.sourceType = TrackDetailsSourceType.Home
                self.navigationController?.pushViewController(viewCont, animated: true)
            })
        }
    }
}
//MARK:- Button Action
extension HomeViewController{
    override func searchButtonAction(sender: UIButton?) {
        super.searchButtonAction(sender)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.HomeStoryboard.searchView) as? UINavigationController {
            UIViewController.getTopMostViewController()?.presentViewController(viewCont, animated: true, completion: nil)
        }
    }
    override func notificationButtonAction(sender: UIButton?) {
        super.notificationButtonAction(sender)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.HomeStoryboard.notificationNavigationView) as? UINavigationController {
            UIViewController.getTopMostViewController()?.presentViewController(viewCont, animated: true, completion: nil)
        }
    }
    @IBAction func filterAction(sender: UIButton) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.HomeStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.HomeStoryboard.filtersView) as? FiltersViewController {
            UIViewController.getTopMostViewController()?.presentViewController(viewCont, animated: true, completion: nil)
        }
    }
    @IBAction func sortAction(sender: UIButton) {
        UIAlertController.showAlertOfStyle(.ActionSheet, Title: nil, Message: nil, OtherButtonTitles: ["NEAR BY LOCATION", "RATING (HIGH TO LOW)"], CancelButtonTitle: "CANCEL") { (tappedAtIndex) in
            print("Clicked at index \(tappedAtIndex)")
        }
    }
}
