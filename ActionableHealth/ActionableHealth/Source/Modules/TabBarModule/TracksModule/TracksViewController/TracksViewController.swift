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
        clctView.registerCells()
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
        
    }
}
