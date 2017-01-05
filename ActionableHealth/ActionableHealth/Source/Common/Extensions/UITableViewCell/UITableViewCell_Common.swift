//
//  UITableViewCell_Common.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 05/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

extension UITableViewCell{
    func getTableView() -> UITableView? {
        if var view = self.superview{
            while !view.isKindOfClass(UITableView.self) {
                if let temp = view.superview {
                    view = temp
                }else{
                    break
                }
            }

            if let tblView = view as? UITableView {
                return tblView
            }
        }
        return nil
    }
}
