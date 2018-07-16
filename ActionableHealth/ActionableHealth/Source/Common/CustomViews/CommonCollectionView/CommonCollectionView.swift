//
//  CommonCollectionView.swift
//  CommonCollectionViewSwift
//
//  Created by Vidhan Nandi on 18/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum CollectionViewType:Int {
    case `default`, templateView, trackView, count
}
protocol CommonCollectionViewDelegate:NSObjectProtocol {
    func topElements(_ view:UIView)
    func bottomElements(_ view:UIView)
    func clickedAtIndexPath(_ indexPath:IndexPath, object:AnyObject)
}
class CommonCollectionView: UICollectionView {

    //MARK:- Variables
    weak var commonCollectionViewDelegate:CommonCollectionViewDelegate?
    var hasMoreData = false
    var dataArray = NSMutableArray()
    var type = CollectionViewType.default{
        didSet{
            registerCells()
        }
    }


    fileprivate var bottomViewVisible = false
    fileprivate var topViewVisible = false
    var topIndicator = UIRefreshControl()

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
        case .templateView, .trackView:
        register(UINib(nibName: String(describing: HomeViewCell), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: HomeViewCell))
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
        topIndicator.addTarget(self, action: #selector(self.topReached), for: UIControlEvents.valueChanged)
        register(UINib(nibName: String(describing: CommonCollectionReusableView), bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: CommonCollectionReusableView))
    }

    func shouldShowBottomViewForSection(_ section:Int) -> Bool {

        if bottomViewVisible && section == numberOfSections - 1  {
            return true
        }
        return false
    }

    func cellForIndexPath(_ indexPath:IndexPath) -> UICollectionViewCell {
        switch type {
        case .templateView, .trackView:
            if let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: HomeViewCell), for: indexPath) as? HomeViewCell {
                cell.configCell(dataArray[indexPath.row] as? TemplatesModel, type: type)
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
        addSubview(topIndicator)
    }

    func removeTopLoader() {
        topIndicator.removeFromSuperview()
    }

    func startTopLoader() {
        topViewVisible = true
        topIndicator.beginRefreshing()
    }

    func stopTopLoader() {
        topViewVisible = false
        topIndicator.endRefreshing()
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let  bounds = scrollView.bounds
        let  size = scrollView.contentSize
        let inset = scrollView.contentInset
        let ytemp = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance = UIScreen.main.bounds.size.height

        if h > reload_distance && ytemp > (h - reload_distance) && hasMoreData && !bottomViewVisible && !topViewVisible {
            bottomReached()
        }
    }
}

//MARK:- UICollectionViewDataSource
extension CommonCollectionView:UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        switch type {
        case .templateView , .trackView:
            return dataArray.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        return cellForIndexPath(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{

        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: CommonCollectionReusableView), for: indexPath) as? CommonCollectionReusableView
        
        return reusableView!
    }
}

//MARK:- UICollectionViewDelegate
extension CommonCollectionView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        commonCollectionViewDelegate?.clickedAtIndexPath(indexPath, object: dataArray[indexPath.row] as AnyObject)
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension CommonCollectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        switch type {
        case .default:
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.width / 2)
        default:
            return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.width / 2)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        if shouldShowBottomViewForSection(section){
            return CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: 80).size
        }
        return CGSize.zero
    }
}
