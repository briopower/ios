//
//  SelectionView.swift
//  ActionableHealth
//
//  Created by Shubhanshu Tibrewal on 10/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum CellName:Int{
    case New , InProgress , Incomplete , Complete , Count
    
    func getStatus(type:CellName) -> String{
        switch type {
        case .New:
            return "NEW"
        case .Complete:
            return "COMPLETE"
        case .InProgress:
            return "IN PROGRESS"
        case .Incomplete:
            return "INCOMPLETE"
        default:
            break
        }
        return ""
    }
    
    func getApiStatus(type:CellName) -> String{
        switch type {
        case .New:
            return "New"
        case .Complete:
            return "Complete"
        case .InProgress:
            return "In progress"
        case .Incomplete:
            return "INCOMPLETE"
        default:
            break
        }
        return ""
    }
    

    
}

class SelectionView: UIView {
    
    //MARK:- Outlets
    @IBOutlet weak var statusTableView: UITableView!
    
    //MARK:- Variables
    var delegate:PhaseDetailsCell? = nil
    var currentStatus:CellName = CellName.New
    var cellCount:Int = 0
    
    class func getInstance() -> UIView{
        let view = UINib.init(nibName: "SelectionView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        return view
    }
}

//Additional Functions
extension SelectionView {
    func setUpCell(status:String) -> () {
        currentStatus =  self.getCellNameForStatus(status)
        statusTableView.dataSource = self
        statusTableView.delegate = self
        statusTableView.registerNib(UINib.init(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        statusTableView.rowHeight = UITableViewAutomaticDimension
        statusTableView.estimatedRowHeight = 200
    }
    
    func getCellNameForStatus(status:String) -> (CellName){
        switch status {
        case "New":
            return CellName.New
        case "Complete":
            return CellName.Complete
        case "In progress":
            return CellName.InProgress
        case "Assigned":
            return CellName.Incomplete
        default:
            return CellName.New
        }
        
    }
    
    func getRowCount(type:CellName) -> Int{
        switch type {
        case .New:
            return 3
        case .Complete:
            return 0
        case .InProgress:
            return 2
        case .Incomplete:
            return 1
        default:
            return 0
        }
    }

}

//MARK:- DataSource
extension SelectionView : UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        cellCount = CellName.Count.rawValue - self.getRowCount(currentStatus)
        return self.getRowCount(currentStatus)
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if let cell = statusTableView.dequeueReusableCellWithIdentifier("SelectionTableViewCell") as? SelectionTableViewCell{
            if let type = CellName.init(rawValue: indexPath.row + cellCount){
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
            if let selectedCell = CellName.init(rawValue: indexPath.row + cellCount){
                localObj.setStatus(selectedCell)
            }
        }
    }
    
    
}
