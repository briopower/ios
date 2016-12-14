//
//  GroupMemberDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 14/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class GroupMemberDetailsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var memberDeatilsTblView: UITableView!
    @IBOutlet var titleView: UIView!
    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var subTitleDescLabel: UILabel!

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitleView(titleView, LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension GroupMemberDetailsViewController{
    func setupView() {
        memberDeatilsTblView.estimatedRowHeight = 80
        memberDeatilsTblView.rowHeight = UITableViewAutomaticDimension
        memberDeatilsTblView.registerNib(UINib(nibName: String(ProfileImageCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(ProfileImageCell))
        memberDeatilsTblView.registerNib(UINib(nibName: String(GroupMemberDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(GroupMemberDetailsCell))

        titleDescLabel.font = titleDescLabel.font.getDynamicSizeFont()
        subTitleDescLabel.font = subTitleDescLabel.font.getDynamicSizeFont()

        titleView.sizeToFit()

        memberDeatilsTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
}

//MARK:- UITableViewDataSource
extension GroupMemberDetailsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupMemberDetailsCellType.Count.rawValue
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let type = GroupMemberDetailsCellType(rawValue: indexPath.row) {
            switch type {
            case .Image:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(ProfileImageCell)) as? ProfileImageCell {
                    cell.configureForMemberImageCell()
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(GroupMemberDetailsCell)) as? GroupMemberDetailsCell {
                    cell.configureCellForType(type)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}
