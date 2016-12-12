//
//  SelectionView.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 10/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum cellName:Int{
    case New , InProgress , incomplete , Complete , count
}

//Protocol SelectionViewProtocol {
//    func getSelectedRow(rowCount:Int)
//}

class SelectionView: UIView {
    //MARK:- Outlets
    @IBOutlet weak var statusTableView: UITableView!
    
    //MARK:- Variables
    var delegate:PhaseDetailsCell? = nil
    
    class func getInstance() -> UIView{
        let view = UINib.init(nibName: "SelectionView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        return view
    }
}

//Additional Functions
extension SelectionView {
    func setUpCell() -> () {
        statusTableView.dataSource = self
        statusTableView.delegate = self
        statusTableView.registerNib(UINib.init(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        statusTableView.rowHeight = UITableViewAutomaticDimension
        statusTableView.estimatedRowHeight = 200
    }
}

//MARK:- DataSource
extension SelectionView : UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cellName.count.rawValue
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if let cell = statusTableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell") as? SelectionTableViewCell{
            if let type = cellName.init(rawValue: indexPath.row){
                cell.setUpcell(type)
                return cell
                
            }
        }
        return UITableViewCell()
    }
}

//MARK:- Delegate
extension SelectionView : UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let localObj = delegate{
        localObj.getSelectedRow(cellName.init(rawValue: indexPath.row)!)
        }
    }
    
    
}
