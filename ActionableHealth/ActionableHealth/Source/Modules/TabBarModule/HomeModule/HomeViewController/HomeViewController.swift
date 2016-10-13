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
    @IBOutlet weak var clctView: UICollectionView!

    //MARK:- Variables
    var imageNameList : Array <NSString> = []

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.Search_Notification)
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
        CommonMethods.addShadowToView(buttonsContainer)
        var index = 0
        while(index<14){
            let imageName = NSString(format: "%d.jpg", index)
            imageNameList.append(imageName)
            index += 1
        }
        clctView.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
    }
}
//MARK:- Button Action
extension HomeViewController{
    @IBAction func filterAction(sender: UIButton) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TabBarStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TabBarStoryboard.filtersView) as? FiltersViewController {
            UIViewController.getTopMostViewController()?.presentViewController(viewCont, animated: true, completion: nil)
        }
    }
    @IBAction func sortAction(sender: UIButton) {
        UIAlertController.showAlertOfStyle(.ActionSheet, Title: nil, Message: nil, OtherButtonTitles: ["NEAR BY LOCATION", "RATING (HIGH TO LOW)"], CancelButtonTitle: "CANCEL") { (tappedAtIndex) in
            print("Clicked at index \(tappedAtIndex)")
        }
    }
}
//MARK:- CHTCollectionViewDelegateWaterfallLayout
extension HomeViewController:CHTCollectionViewDelegateWaterfallLayout{
    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let image:UIImage! = UIImage(named: self.imageNameList[indexPath.row] as String)
        let gridWidth : CGFloat = (UIScreen.mainScreen().bounds.size.width/2)-5.0
        let imageHeight = image.size.height*gridWidth/image.size.width
        return CGSizeMake(gridWidth, imageHeight)
    }
}

//MARK:- UICollectionViewDataSource
extension HomeViewController:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNameList.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        return UICollectionViewCell()
    }
}
//MARK:- UICollectionViewDelegate
extension HomeViewController:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
    }
}
