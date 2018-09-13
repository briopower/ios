//
//  CommonTableView.swift
//  CommonTableView
//
//  Created by Vidhan Nandi on 14/07/16.
//  Copyright © 2016 Freshworks. All rights reserved.
//

import UIKit
enum TableViewType:Int {
    case `default`, comments, count
}
enum InsertAt:Int {
    case top, bottom, middle
}
protocol CommonTableViewDelegate :NSObjectProtocol{
    func topElements(_ view:UIView)
    func bottomElements(_ view:UIView)
    func clickedAtIndexPath(_ indexPath:IndexPath,obj:AnyObject)
}
class CommonTableView: UITableView {

    //MARK:- Variables
    weak var commonTableViewDelegate:CommonTableViewDelegate?
    var dataArray:NSMutableArray = []
    var topIndicator = UIRefreshControl()
    var animatedFooter = UIView()
    var tableViewType = TableViewType.default{
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

        topIndicator.addTarget(self, action: #selector(self.topElements(_:)), for: UIControlEvents.valueChanged)

        animatedFooter.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.color = UIColor.black
        activityIndicator.center = animatedFooter.center
        activityIndicator.startAnimating()
        animatedFooter.addSubview(activityIndicator)
        registerCells()
    }

    func registerCells() {
        switch tableViewType {
        case .comments:
            self.register(UINib(nibName: String(describing: CommnetsCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: CommnetsCell.self))
        default:
            break
        }
    }
    func checkForLastCell(_ indexPath:IndexPath) {
        if self.tableFooterView == nil && hasMoreActivity && tableView(self, numberOfRowsInSection: indexPath.section) - 1 == indexPath.row{
            if self.responds(to: #selector(self.bottomElements(_:)))
            {
                addBottomLoader()
                bottomElements(self)
            }
        }
    }

}


//MARK:- UITableViewDataSource
extension CommonTableView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(tableView, cellForRowAtIndexPath: indexPath)
    }


    func getCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        checkForLastCell(indexPath)
        switch tableViewType {
        case .comments:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommnetsCell.self)) as? CommnetsCell, let obj = dataArray[indexPath.row] as? CommentsModel{
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        commonTableViewDelegate?.clickedAtIndexPath(indexPath, obj: dataArray[indexPath.row] as AnyObject)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableViewType {
        case .comments:
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
    func addTopLoader(_ text:String?, tintColor:UIColor = UIColor.darkGray) {
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
    @IBAction func topElements(_ sender:UIRefreshControl) {
        commonTableViewDelegate?.topElements(self)
    }

    //MARK: Bottom reached
    func addBottomLoader(){
        self.tableFooterView = animatedFooter
    }
    func removeBottomLoader(){

        self.tableFooterView = nil
    }
    @IBAction func bottomElements(_ sender:AnyObject) {
        commonTableViewDelegate?.bottomElements(self)
    }
}

//MARK:- Insertion Methods
extension CommonTableView{
    func insertElements(_ array:NSMutableArray, insertAt:InsertAt = .bottom, section:Int = 0, startIndex:Int = 0) {
        if array.count > 0 {
            let indexPathArr = getIndexPathsArray(insertAt, count: array.count, section: section,startIndex: startIndex)
            self.beginUpdates()
            switch insertAt {
            case .top:
                //dataArray.insert(array as [AnyObject], at: IndexSet(integersIn: NSRange.init(location: startIndex, length: array.count).toRange() ?? 0..<0))
                dataArray.insert(array as! [Any], at: IndexSet.init(integersIn: Range.init(NSRange.init(location: startIndex, length: array.count )) ?? 0..<0))
                self.insertRows(at: indexPathArr, with: .top)

            case  .middle:
                //dataArray.insert(array as [AnyObject], at: IndexSet(integersIn: NSRange.init(location: startIndex, length: array.count).toRange() ?? 0..<0))
                dataArray.insert(array as! [Any], at: IndexSet.init(integersIn: Range.init(NSRange.init(location: startIndex, length: array.count )) ?? 0..<0))
                self.insertRows(at: indexPathArr, with: .middle)

            case .bottom:
                dataArray.addObjects(from: array as [AnyObject])
                self.insertRows(at: indexPathArr, with: .automatic)
            }
            self.endUpdates()
        }else{
            hasMoreActivity = false
        }
        stopTopLoader()
        removeBottomLoader()
    }

    func getIndexPathsArray(_ insertAt:InsertAt = .bottom, count:Int, section:Int, startIndex:Int) -> [IndexPath]{
        var indexPathsArr:[IndexPath] = []
        switch insertAt {
        case .top, .middle:
            for i in startIndex..<(count + startIndex) {
                let  indexPath = IndexPath(row: i, section: section)
                indexPathsArr.append(indexPath)
            }
        case .bottom:
            for i in 0..<count {
                let  indexPath = IndexPath(row: dataArray.count+i, section: section)
                indexPathsArr.append(indexPath)
            }
        }
        return indexPathsArr
    }

}

//MARK:- Deletion Methods
extension CommonTableView{

    func deleteObjects(_ objectsArr:NSMutableArray, section:Int = 0, animation:UITableViewRowAnimation = .automatic) {
        self.beginUpdates()
        let arr = getIndexPathsArray(objectsArr, section: section)
        deleteObjects(arr)
        self.deleteRows(at: arr, with: animation)
        self.endUpdates()
    }

    func getIndexPathsArray(_ objectsArr:NSMutableArray, section:Int = 0) -> [IndexPath] {
        var indexPathsArr:[IndexPath] = []

        for obj in objectsArr {
            if dataArray.contains(obj) {
                indexPathsArr.append(IndexPath(row: dataArray.index(of: obj), section: section))
            }
        }
        return indexPathsArr
    }

    func deleteObjects(_ indexPathArr:[IndexPath]) {
        for indexPath in indexPathArr {
            if indexPath.row < dataArray.count {
                dataArray.removeObject(at: indexPath.row)
            }
        }
    }
}
