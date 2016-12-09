//
//  TrackMemberListViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 09/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TrackMemberListViewController: CommonViewController {

    @IBOutlet weak var tblVIew: UITableView!
    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    override func viewWillAppear(animated: Bool) {
        setNavigationBarWithTitle("Members", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additonal methods
extension TrackMemberListViewController{
    func setupView() {
        tblVIew.estimatedRowHeight = 100
        tblVIew.rowHeight = UITableViewAutomaticDimension
        tblVIew.registerNib(UINib(nibName: String(GroupsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(GroupsCell))
    }
}


//MARK:- UITableViewDataSource
extension TrackMemberListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(GroupsCell)) as? GroupsCell {
            cell.configureForGroupMemberCell()
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension TrackMemberListViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.MessagingStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.MessagingStoryboard.messagingView) as? MessagingViewController {
            dispatch_async(dispatch_get_main_queue(), {
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }
}
