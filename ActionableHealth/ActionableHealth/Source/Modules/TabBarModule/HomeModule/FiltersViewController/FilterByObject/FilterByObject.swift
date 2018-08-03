//
//  FilterByObject.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class FilterByObject: NSObject {
    //MARK:- Variables
    var subProperties = NSMutableArray()

    //MARK:- Additional methods

    func selectSubProperty(_ subProperty:SubProperties) {
        for obj in subProperties {
            if let prop = obj as? SubProperties {
                if prop == subProperty {
                    prop.isSelected = !(prop.isSelected)
                }
            }
        }
    }

    func deselectAllSubProperties() {
        for obj in subProperties {
            if let prop = obj as? SubProperties {
              prop.isSelected = false
            }
        }
    }
    
    func getAllSelectedSubproperties() -> NSArray{
        var arr = [String]()
        for obj in subProperties {
            if let prop = obj as? SubProperties {
                if prop.isSelected == true{
                    arr.append(prop.name)
                }
            }
        }
        return arr as NSArray
    }
}

//MARK:- ------------------
class SubProperties: NSObject {
    //MARK:- Variables
    var name = ""
    var isSelected = false
}
