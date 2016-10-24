//
//  TracksViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TracksViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var clctView: StaggeredCollectionView!

    //MARK:- Variables

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("TRACKS", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
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
extension TracksViewController{
    func setupView() {
        clctView.commonCollectionViewDelegate = self
        clctView.dataArray = NSMutableArray()
        clctView.type = CollectionViewType.HomeView
        clctView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
}
//MARK:- CommonCollectionViewDelegate
extension TracksViewController:CommonCollectionViewDelegate{
    func topElements(view: UIView) {

    }

    func bottomElements(view: UIView) {

    }

    func clickedAtIndexPath(indexPath: NSIndexPath, object: AnyObject) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackDetailsView) as? TrackDetailsViewController {
            dispatch_async(dispatch_get_main_queue(), {
                viewCont.sourceType = TrackDetailsSourceType.Tracks
                self.navigationController?.pushViewController(viewCont, animated: true)
            })
        }
    }
}
