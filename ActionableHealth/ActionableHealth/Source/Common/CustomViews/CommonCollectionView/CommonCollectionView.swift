//
//  CommonCollectionView.swift
//  CommonCollectionViewSwift
//
//  Created by Vidhan Nandi on 18/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum CollectionViewType:Int {
    case Default, HomeView,  Count
}
protocol CommonCollectionViewDelegate:NSObjectProtocol {
    func topElements(view:UIView)
    func bottomElements(view:UIView)
    func clickedAtIndexPath(indexPath:NSIndexPath, object:AnyObject)
}
class CommonCollectionView: UICollectionView {

    //MARK:- Variables
    weak var commonCollectionViewDelegate:CommonCollectionViewDelegate?
    var hasMoreData = false
    var dataArray = NSMutableArray()
    var type = CollectionViewType.Default{
        didSet{
            registerCells()
        }
    }


    private var bottomViewVisible = false
    private var topViewVisible = false
    private var refreshControl = UIRefreshControl()

    //MARK:- Init Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
    }

}

//MARK:- Public Methods
extension CommonCollectionView{
    func registerCells() {
        switch type {
        case .HomeView:
        registerNib(UINib(nibName: String(HomeViewCell), bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: String(HomeViewCell))
        default:
            break
        }
    }

    func reloadContent() {
        stopTopLoader()
        removeBottomLoader()
    }

}
//MARK:- Additional methods
extension CommonCollectionView{
    func setupView() {
        delegate = self
        dataSource = self
        registerNib(UINib(nibName: String(CommonCollectionReusableView), bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(CommonCollectionReusableView))
    }

    func shouldShowBottomViewForSection(section:Int) -> Bool {

        if bottomViewVisible && section == numberOfSections() - 1  {
            return true
        }
        return false
    }

    func cellForIndexPath(indexPath:NSIndexPath) -> UICollectionViewCell {
        switch type {
        case .HomeView:
            if let cell = self.dequeueReusableCellWithReuseIdentifier(String(HomeViewCell), forIndexPath: indexPath) as? HomeViewCell {
                return cell
            }
        default:
            break
        }
        return UICollectionViewCell()
    }
}

//MARK:- TOP LOADER
extension CommonCollectionView{
    func addTopLoader() {
        addSubview(refreshControl)
    }

    func removeTopLoader() {
        refreshControl.removeFromSuperview()
    }

    func startTopLoader() {
        topViewVisible = true
        refreshControl.beginRefreshing()
    }

    func stopTopLoader() {
        topViewVisible = false
        refreshControl.endRefreshing()
    }

    func topReached() {
        topViewVisible = true
        commonCollectionViewDelegate?.topElements(self)
    }
}

//MARK:- Bottom Loader
extension CommonCollectionView{
    func addBottomLoader() {
        bottomViewVisible = true
        reloadData()
    }

    func removeBottomLoader() {
        bottomViewVisible = false
        reloadData()
    }

    func bottomReached() {
        addBottomLoader()
        commonCollectionViewDelegate?.bottomElements(self)
    }
}

//MARK:- ScrollViewDelegate
extension CommonCollectionView:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let  bounds = scrollView.bounds
        let  size = scrollView.contentSize
        let inset = scrollView.contentInset
        let ytemp = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance = UIScreen.mainScreen().bounds.size.height

        if h > reload_distance && ytemp > (h - reload_distance) && hasMoreData && !bottomViewVisible && !topViewVisible {
            bottomReached()
        }
    }
}

//MARK:- UICollectionViewDataSource
extension CommonCollectionView:UICollectionViewDataSource{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        switch type {
        case .HomeView:
            return dataArray.count
        default:
            return 0
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        return cellForIndexPath(indexPath)
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{

        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: String(CommonCollectionReusableView), forIndexPath: indexPath) as? CommonCollectionReusableView
        
        return reusableView!
    }
}

//MARK:- UICollectionViewDelegate
extension CommonCollectionView:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        commonCollectionViewDelegate?.clickedAtIndexPath(indexPath, object: dataArray[indexPath.row])
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension CommonCollectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        switch type {
        case .Default:
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.width / 2)
        default:
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.width / 2)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        if shouldShowBottomViewForSection(section){
            return CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: 80).size
        }
        return CGSizeZero
    }
}