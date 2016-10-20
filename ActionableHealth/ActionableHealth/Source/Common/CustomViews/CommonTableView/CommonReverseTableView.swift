//
//  CommonReverseTableView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum ReverseTableViewType:Int {
    case Default, Comments, Count
}
protocol ReverseTableViewDelegate :NSObjectProtocol{
    func topElements(view:UIView)
    func clickedAtIndexPath(indexPath:NSIndexPath,obj:AnyObject)
}

class CommonReverseTableView: UITableView {

    //MARK:- Variables
    weak var reverseTableViewDelegate:ReverseTableViewDelegate?
    var dataArray:NSMutableArray = []
    var animatedHeader = UIView()
    var tableViewType = ReverseTableViewType.Default{
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
extension CommonReverseTableView{
    func setupView() {
        self.delegate = self
        self.dataSource = self
        self.estimatedRowHeight = 44
        self.rowHeight = UITableViewAutomaticDimension
        self.tableHeaderView = nil

        animatedHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 44)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.color = UIColor.blackColor()
        activityIndicator.center = animatedHeader.center
        activityIndicator.startAnimating()
        animatedHeader.addSubview(activityIndicator)
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
}

//MARK:- UIScrollViewDelegate
extension CommonReverseTableView:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let size = scrollView.contentSize

        let yTemp = offset.y

        let h = size.height

        let reload_distance = UIScreen.mainScreen().bounds.size.height

        if h > reload_distance && yTemp - reload_distance <= 0 && hasMoreActivity && self.tableHeaderView == nil
        {
            if self.respondsToSelector(#selector(self.topElements(_:)))
            {
                addTopLoader()
                topElements(scrollView)
            }
        }
    }
}
//MARK:- UITableViewDataSource
extension CommonReverseTableView:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return getCell(tableView, cellForRowAtIndexPath: indexPath)
    }


    func getCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch tableViewType {
        case .Comments:
            if let cell = tableView.dequeueReusableCellWithIdentifier(String(CommnetsCell)) as? CommnetsCell{
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension CommonReverseTableView:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        reverseTableViewDelegate?.clickedAtIndexPath(indexPath, obj: dataArray[indexPath.row])
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//MARK:- Advance loading methods
extension CommonReverseTableView{

    //MARK: Bottom reached
    func addTopLoader(){
        self.tableHeaderView = animatedHeader
    }
    func removeTopLoader(){

        self.tableHeaderView = nil
    }
    @IBAction func topElements(sender:AnyObject) {
        reverseTableViewDelegate?.topElements(self)
    }
}

//MARK:- Insertion Methods
extension CommonReverseTableView{
    func insertElements(array:NSMutableArray, insertAt:InsertAt = .Bottom, section:Int = 0, startIndex:Int = 0) {
        if array.count > 0 {
            let indexPathArr = getIndexPathsArray(insertAt, count: array.count, section: section,startIndex: startIndex)
            self.beginUpdates()
            switch insertAt {
            case .Top:
                dataArray.insertObjects(array as [AnyObject], atIndexes: NSIndexSet(indexesInRange: NSRange.init(location: startIndex, length: array.count)))
                self.insertRowsAtIndexPaths(indexPathArr, withRowAnimation: UITableViewRowAnimation.Top)

            case  .Middle:
                dataArray.insertObjects(array as [AnyObject], atIndexes: NSIndexSet(indexesInRange: NSRange.init(location: startIndex, length: array.count)))
                self.insertRowsAtIndexPaths(indexPathArr, withRowAnimation: UITableViewRowAnimation.Middle)

            case .Bottom:
                dataArray.addObjectsFromArray(array as [AnyObject])
                self.insertRowsAtIndexPaths(indexPathArr, withRowAnimation: UITableViewRowAnimation.Automatic)
            }

            self.endUpdates()
        }else{
            hasMoreActivity = false
        }
        removeTopLoader()
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
extension CommonReverseTableView{

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