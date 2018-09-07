//
//  UITableView_Common.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/17/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UITableView
extension UITableView {
    
    func setNoDataView(textColor: UIColor = UIColor.black, message: String = "No data available") {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.bounds.size.height))
        noDataLabel.text          = message
        noDataLabel.textColor     = textColor
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = .center
        noDataLabel.tag = 999
        self.backgroundView  = noDataLabel
    }
    
    func removeNoDataView() {
        if self.backgroundView?.viewWithTag(999) != nil {
            self.backgroundView = nil
        }
    }
    
    func scrollToLastRow(animated: Bool, atPosition scrollPosition: UITableViewScrollPosition? = .bottom) {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0), at: scrollPosition ?? .bottom, animated: animated)
        }
    }

}
