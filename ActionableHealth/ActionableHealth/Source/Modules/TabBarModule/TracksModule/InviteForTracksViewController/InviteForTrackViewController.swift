//
//  InviteForTrackViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class InviteForTrackViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("INVITE FOR TRACK", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//MARK:- Additional methods
extension InviteForTrackViewController{
    func setupView() {
        tblView.registerNib(UINib(nibName: String(InviteForTrackCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(InviteForTrackCell))
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 80
    }
}

//MARK:- UITableViewDataSource
extension InviteForTrackViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier(String(InviteForTrackCell)) as? InviteForTrackCell {
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension InviteForTrackViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}
