//
//  SubPropertiesTableView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
protocol SubPropertiesTableViewDelagate:NSObjectProtocol {
    func subPropertySelected(selectedSubProperty:SubProperties, index:Int)
}

class SubPropertiesTableView: UITableView {

    //MARK:- Variables
    weak var subPropertiesTableViewDelegate:SubPropertiesTableViewDelagate?
    var dataArray = NSMutableArray()

    //MARK:- Additional methods
    func setupTableView() {
        self.registerNib(UINib(nibName: String(SubPropertiesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(SubPropertiesCell))
        self.dataSource = self
        self.delegate = self
        self.estimatedRowHeight = 80
        self.rowHeight = UITableViewAutomaticDimension
        self.reloadData()
    }
}

//MARK:- UITableViewDataSource
extension SubPropertiesTableView: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(SubPropertiesCell)) as? SubPropertiesCell {
            if let obj = dataArray[indexPath.row] as? SubProperties {
                cell.configureCell(obj)
                return cell
            }
        }
        return UITableViewCell()
    }
}
//MARK:- UITableViewDataSource
extension SubPropertiesTableView: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let obj = dataArray[indexPath.row] as? SubProperties {
            subPropertiesTableViewDelegate?.subPropertySelected(obj, index: indexPath.row)
        }
    }
}
