//
//  CommonTableView.swift
//  CommonTableView
//
//  Created by Vidhan Nandi on 14/07/16.
//  Copyright © 2016 Freshworks. All rights reserved.
//

import UIKit
enum TableViewType:Int {
    case Default, Comments, Count
}
enum InsertAt:Int {
    case Top, Bottom, Middle
}
protocol CommonTableViewDelegate :NSObjectProtocol{
    func topElements(view:UIView)
    func bottomElements(view:UIView)
    func clickedAtIndexPath(indexPath:NSIndexPath,obj:AnyObject)
}
class CommonTableView: UITableView {

    //MARK:- Variables
    weak var commonTableViewDelegate:CommonTableViewDelegate?
    var dataArray:NSMutableArray = []
    var topIndicator = UIRefreshControl()
    var animatedFooter = UIView()
    var tableViewType = TableViewType.Default{
        didSet{
            registerCells()
        }
    }

    var hasMoreActivity = false

    //MARK:- Init methods
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

//MARK:- Additonal Methods
extension CommonTableView{
    func setupView() {
        self.delegate = self
        self.dataSource = self
        self.estimatedRowHeight = 44
        self.rowHeight = UITableViewAutomaticDimension
        self.tableFooterView = nil

        topIndicator.addTarget(self, action: #selector(self.topElements(_:)), forControlEvents: UIControlEvents.ValueChanged)

        animatedFooter.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 44)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.color = UIColor.blackColor()
        activityIndicator.center = animatedFooter.center
        activityIndicator.startAnimating()
        animatedFooter.addSubview(activityIndicator)
        registerCells()
    }

    func registerCells() {
        switch tableViewType {
        case .Comments:
            self.registerNib(UINib(nibName: String(CommnetsCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(CommnetsCell))
        default:
            break
        }
    }
    func checkForLastCell(indexPath:NSIndexPath) {
        if self.tableFooterView == nil && hasMoreActivity && tableView(self, numberOfRowsInSection: indexPath.section) - 1 == indexPath.row{
            if self.respondsToSelector(#selector(self.bottomElements(_:)))
            {
                addBottomLoader()
                bottomElements(self)
            }
        }
    }

}


//MARK:- UITableViewDataSource
extension CommonTableView:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return getCell(tableView, cellForRowAtIndexPath: indexPath)
    }


    func getCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        checkForLastCell(indexPath)
        switch tableViewType {
        case .Comments:
            if let cell = tableView.dequeueReusableCellWithIdentifier(String(CommnetsCell)) as? CommnetsCell, let obj = dataArray[indexPath.row] as? CommentsModel{
                cell.configCell(obj)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension CommonTableView:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        commonTableViewDelegate?.clickedAtIndexPath(indexPath, obj: dataArray[indexPath.row])
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableViewType {
        case .Comments:
            if let estimate = (dataArray[indexPath.row] as? CommentsModel)?.comment.getHeight(UIFont.getAppRegularFontWithSize(16), maxWidth: Double(UIDevice.width()) * 240/320) {
                return estimate + 60
            }
        default:
            break
        }

        return self.estimatedRowHeight

    }
}

//MARK:- Advance loading methods
extension CommonTableView{

    //MARK: Top loader
    func addTopLoader(text:String?, tintColor:UIColor = UIColor.darkGrayColor()) {
        topIndicator.removeFromSuperview()
        if let title = text {
            topIndicator.attributedTitle = NSAttributedString(string: title)
        }
        topIndicator.tintColor = tintColor
        self.addSubview(topIndicator)
    }
    func removeTopLoader() {
        topIndicator.removeFromSuperview()
    }
    func stopTopLoader() {
        topIndicator.endRefreshing()
    }
    @IBAction func topElements(sender:UIRefreshControl) {
        commonTableViewDelegate?.topElements(self)
    }

    //MARK: Bottom reached
    func addBottomLoader(){
        self.tableFooterView = animatedFooter
    }
    func removeBottomLoader(){

        self.tableFooterView = nil
    }
    @IBAction func bottomElements(sender:AnyObject) {
        commonTableViewDelegate?.bottomElements(self)
    }
}

//MARK:- Insertion Methods
extension CommonTableView{
    func insertElements(array:NSMutableArray, insertAt:InsertAt = .Bottom, section:Int = 0, startIndex:Int = 0) {
        if array.count > 0 {
            let indexPathArr = getIndexPathsArray(insertAt, count: array.count, section: section,startIndex: startIndex)
            self.beginUpdates()
            switch insertAt {
            case .Top:
                dataArray.insertObjects(array as [AnyObject], atIndexes: NSIndexSet(indexesInRange: NSRange.init(location: startIndex, length: array.count)))
                self.insertRowsAtIndexPaths(indexPathArr, withRowAnimation: .Top)

            case  .Middle:
                dataArray.insertObjects(array as [AnyObject], atIndexes: NSIndexSet(indexesInRange: NSRange.init(location: startIndex, length: array.count)))
                self.insertRowsAtIndexPaths(indexPathArr, withRowAnimation: .Middle)

            case .Bottom:
                dataArray.addObjectsFromArray(array as [AnyObject])
                self.insertRowsAtIndexPaths(indexPathArr, withRowAnimation: .Automatic)
            }
            self.endUpdates()
        }else{
            hasMoreActivity = false
        }
        stopTopLoader()
        removeBottomLoader()
    }

    func getIndexPathsArray(insertAt:InsertAt = .Bottom, count:Int, section:Int, startIndex:Int) -> [NSIndexPath]{
        var indexPathsArr:[NSIndexPath] = []
        switch insertAt {
        case .Top, .Middle:
            for i in startIndex..<(count + startIndex) {
                let  indexPath = NSIndexPath(forRow: i, inSection: section)
                indexPathsArr.append(indexPath)
            }
        case .Bottom:
            for i in 0..<count {
                let  indexPath = NSIndexPath(forRow: dataArray.count+i, inSection: section)
                indexPathsArr.append(indexPath)
            }
        }
        return indexPathsArr
    }

}

//MARK:- Deletion Methods
extension CommonTableView{

    func deleteObjects(objectsArr:NSMutableArray, section:Int = 0, animation:UITableViewRowAnimation = .Automatic) {
        self.beginUpdates()
        let arr = getIndexPathsArray(objectsArr, section: section)
        deleteObjects(arr)
        self.deleteRowsAtIndexPaths(arr, withRowAnimation: animation)
        self.endUpdates()
    }

    func getIndexPathsArray(objectsArr:NSMutableArray, section:Int = 0) -> [NSIndexPath] {
        var indexPathsArr:[NSIndexPath] = []

        for obj in objectsArr {
            if dataArray.containsObject(obj) {
                indexPathsArr.append(NSIndexPath(forRow: dataArray.indexOfObject(obj), inSection: section))
            }
        }
        return indexPathsArr
    }

    func deleteObjects(indexPathArr:[NSIndexPath]) {
        for indexPath in indexPathArr {
            if indexPath.row < dataArray.count {
                dataArray.removeObjectAtIndex(indexPath.row)
            }
        }
    }
}
