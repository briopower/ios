//
//  SubPropertiesTableView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
protocol SubPropertiesTableViewDelagate:NSObjectProtocol {
    func subPropertySelected(_ selectedSubProperty:SubProperties, index:Int)
}

class SubPropertiesTableView: UITableView {

    //MARK:- Variables
    weak var subPropertiesTableViewDelegate:SubPropertiesTableViewDelagate?
    var dataArray = NSMutableArray()

    //MARK:- Additional methods
    func setupTableView() {
        self.register(UINib(nibName: String(describing: SubPropertiesCell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: SubPropertiesCell))
        self.dataSource = self
        self.delegate = self
        self.estimatedRowHeight = 80
        self.rowHeight = UITableViewAutomaticDimension
        self.reloadData()
    }
}

//MARK:- UITableViewDataSource
extension SubPropertiesTableView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SubPropertiesCell)) as? SubPropertiesCell {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let obj = dataArray[indexPath.row] as? SubProperties {
            subPropertiesTableViewDelegate?.subPropertySelected(obj, index: indexPath.row)
        }
    }
}
