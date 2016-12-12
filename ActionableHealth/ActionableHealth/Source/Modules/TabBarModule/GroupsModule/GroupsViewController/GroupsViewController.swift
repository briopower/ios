//
//  GroupsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 07/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class GroupsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var groupTblView: UITableView!

    //MARK:- Variables

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("Groups", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additonal methods
extension GroupsViewController{
    func setupView() {
        groupTblView.estimatedRowHeight = 100
        groupTblView.rowHeight = UITableViewAutomaticDimension
        groupTblView.registerNib(UINib(nibName: String(GroupsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(GroupsCell))
    }
}

//MARK:- UITableViewDataSource
extension GroupsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(GroupsCell)) as? GroupsCell {
            cell.configureForGroupCell()
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension GroupsViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.GroupsStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.GroupsStoryboard.groupMemberView) as? GroupMembersViewController {
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}
