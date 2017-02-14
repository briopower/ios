//
//  FilesListViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/02/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class FilesListViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var nullCaseLabel: UILabel!

    //MARK:- Variables
    var resources = NSMutableArray()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("Resources", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional Methods
extension FilesListViewController{
    func setupView(){
        tblView.registerNib(UINib(nibName: String(FilesCell), bundle: nil), forCellReuseIdentifier: String(FilesCell))
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableViewAutomaticDimension
    }
}

//MARK:- UITableViewDataSource
extension FilesListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfCell = resources.count
        if numberOfCell == 0 {
            UIView.showToast("No Files Found.", theme: Theme.Warning)
            nullCaseLabel.hidden = false
        }else{
            nullCaseLabel.hidden = true
        }
        return numberOfCell
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(FilesCell)) as? FilesCell, let resourceObj = resources[indexPath.row] as? Resources{
            cell.configCell(resourceObj)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension FilesListViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController,let resourceObj = resources[indexPath.row] as? Resources {
            viewCont.blobKey = resourceObj.blobKey
            viewCont.navigationTitle = resourceObj.fileName
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}
