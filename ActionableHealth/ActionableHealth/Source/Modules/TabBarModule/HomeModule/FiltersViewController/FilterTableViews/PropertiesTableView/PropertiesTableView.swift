//
//  PropertiesTableView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
protocol PropertiesTableViewDelegate:NSObjectProtocol {
    func propertySelected(selectedProperty:Properties, index:Int)
}

class PropertiesTableView: UITableView {

    //MARK:- Variables
    weak var propertiesTableViewDelegate:PropertiesTableViewDelegate?
    var dataArray = NSMutableArray()

    //MARK:- Additional methods
    func setupTableView() {
        self.registerNib(UINib(nibName: String(PropertiesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(PropertiesCell))
        self.dataSource = self
        self.delegate = self
        self.estimatedRowHeight = 80
        self.rowHeight = UITableViewAutomaticDimension
        self.reloadData()
    }
}

//MARK:- UITableViewDataSource
extension PropertiesTableView: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(String(PropertiesCell)) as? PropertiesCell {
            if let obj = dataArray[indexPath.row] as? Properties {
                cell.configureCell(obj)
                return cell
            }
        }
        return UITableViewCell()
    }
}
//MARK:- UITableViewDataSource
extension PropertiesTableView: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let obj = dataArray[indexPath.row] as? Properties {
            propertiesTableViewDelegate?.propertySelected(obj, index: indexPath.row)
        }
    }
}
