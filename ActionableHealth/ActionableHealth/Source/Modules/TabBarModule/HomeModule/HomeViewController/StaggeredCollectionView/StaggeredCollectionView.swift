//
//  StaggeredCollectionView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 18/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class StaggeredCollectionView: CommonCollectionView {

    //MARK:- InitMethods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
}

//MARK:- overriden methods
extension StaggeredCollectionView{
    override func setupView() {
        super.setupView()
        registerNib(UINib(nibName: String(CommonCollectionReusableView), bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: "CHTCollectionElementKindSectionFooter", withReuseIdentifier: String(CommonCollectionReusableView))
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind("CHTCollectionElementKindSectionFooter", withReuseIdentifier: String(CommonCollectionReusableView), forIndexPath: indexPath) as? CommonCollectionReusableView
        return reusableView!
    }
}

//MARK:- CHTCollectionViewDelegateWaterfallLayout
extension StaggeredCollectionView:CHTCollectionViewDelegateWaterfallLayout{
    override func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let gridWidth : CGFloat = (UIScreen.mainScreen().bounds.size.width/2)-5.0
        let imageHeight = 1250*gridWidth/1250
        return CGSizeMake(gridWidth, imageHeight)
    }
    func colletionView (collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        heightForFooterInSection section: NSInteger) -> CGFloat{
        if shouldShowBottomViewForSection(section){
            return 50
        }
        return 0
    }
}