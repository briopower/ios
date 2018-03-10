//
//  CommonReverseTableView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class CommonReverseTableView: CommonTableView {

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



//MARK:- overriden Methods
extension CommonReverseTableView{


    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset

        let yTemp = offset.y + bounds.size.height - inset.bottom

        let h = size.height

        let reload_distance = CGFloat(0)

        if h > reload_distance && yTemp > (h - reload_distance) && hasMoreActivity && self.tableFooterView == nil
        {
            if self.respondsToSelector(#selector(self.bottomElements(_:)))
            {
                addBottomLoader()
                commonTableViewDelegate?.topElements(self)
            }
        }
    }
}
