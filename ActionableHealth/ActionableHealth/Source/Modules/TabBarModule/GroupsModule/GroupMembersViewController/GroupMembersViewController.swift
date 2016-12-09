//
//  GroupMembersViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class GroupMembersViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var groupMembersTblView: UITableView!

    //MARK:- Variables

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithTitle("FITNESS GROUP", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
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
extension GroupMembersViewController{
    func setupView() {
        groupMembersTblView.estimatedRowHeight = 100
        groupMembersTblView.rowHeight = UITableViewAutomaticDimension
        groupMembersTblView.registerNib(UINib(nibName: String(GroupsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(GroupsCell))
    }
}


//MARK:- UITableViewDataSource
extension GroupMembersViewController:UITableViewDataSource{
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
extension GroupMembersViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.GroupsStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.GroupsStoryboard.memberDetailsView) as? GroupMemberDetailsViewController {
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }
}
