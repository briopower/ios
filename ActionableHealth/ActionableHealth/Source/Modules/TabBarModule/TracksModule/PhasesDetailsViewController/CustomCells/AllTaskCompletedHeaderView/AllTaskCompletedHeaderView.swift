//
//  AllTaskCompletedHeaderView.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class AllTaskCompletedHeaderView: UIView {

    //MARK:- Variables
    static let heightOf1PxlWidth:CGFloat = 0.1771336554
    
}
//MARK:- Additional methods
extension AllTaskCompletedHeaderView{
    class func getView() -> AllTaskCompletedHeaderView? {
        if let nibArr = NSBundle.mainBundle().loadNibNamed(String(AllTaskCompletedHeaderView), owner: nil, options: nil){
            for view in nibArr {
                if let headerView = view as? AllTaskCompletedHeaderView
                {
                    headerView.setupFrame()
                    return headerView
                }
            }
        }


        return nil
    }

    func setupFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIDevice.width(), height: UIDevice.width() * AllTaskCompletedHeaderView.heightOf1PxlWidth)
    }
}


