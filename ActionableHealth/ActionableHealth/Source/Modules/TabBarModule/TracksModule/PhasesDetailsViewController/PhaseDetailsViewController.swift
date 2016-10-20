//
//  PhaseDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class PhaseDetailsViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var phaseDetailsTblView: UITableView!

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("MONDAY", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = phaseDetailsTblView.tableHeaderView as? AllTaskCompletedHeaderView {
            headerView.setupFrame()
            phaseDetailsTblView.tableHeaderView = headerView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- Additional methods
extension PhaseDetailsViewController{
    func setupView(){

        if let headerView = AllTaskCompletedHeaderView.getView() {
            phaseDetailsTblView.tableHeaderView = headerView
        }

        phaseDetailsTblView.rowHeight = UITableViewAutomaticDimension
        phaseDetailsTblView.estimatedRowHeight = 100
        phaseDetailsTblView.registerNib(UINib(nibName: String(PhaseDetailsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(PhaseDetailsCell))
        phaseDetailsTblView.registerNib(UINib(nibName: PhaseDetailsCell.statusCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: PhaseDetailsCell.statusCell)
    }
}

//MARK:- UITableViewDataSource
extension PhaseDetailsViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 || indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCellWithIdentifier(String(PhaseDetailsCell)) as? PhaseDetailsCell {
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCellWithIdentifier(PhaseDetailsCell.statusCell) as? PhaseDetailsCell {
                return cell
            }
        }
        return UITableViewCell()
    }
}
