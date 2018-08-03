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
    @objc override func setupView() {
        super.setupView()
        register(UINib(nibName: String(describing: CommonCollectionReusableView.self), bundle: Bundle.main), forSupplementaryViewOfKind: "CHTCollectionElementKindSectionFooter", withReuseIdentifier: String(describing: CommonCollectionReusableView.self))
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: "CHTCollectionElementKindSectionFooter", withReuseIdentifier: String(describing: CommonCollectionReusableView.self), for: indexPath) as? CommonCollectionReusableView
        return reusableView!
    }
}

//MARK:- CHTCollectionViewDelegateWaterfallLayout
extension StaggeredCollectionView:CHTCollectionViewDelegateWaterfallLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let gridWidth : CGFloat = (UIScreen.main.bounds.size.width/2)-5.0
        let imageHeight = 1250*gridWidth/1250
        return CGSize(width: gridWidth, height: imageHeight)
    }
    func colletionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        heightForFooterInSection section: NSInteger) -> CGFloat{
        if shouldShowBottomViewForSection(section){
            return 50
        }
        return 0
    }
}
