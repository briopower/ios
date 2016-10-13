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
    var properties = NSMutableArray()

    //MARK:- Additional methods

    func getSortDescriptors() -> [NSSortDescriptor] {
        let sortDescriptor_name = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor_isSelected = NSSortDescriptor(key: "isSelected", ascending: false)
        return [sortDescriptor_isSelected, sortDescriptor_name]
    }
    func sortProperties() {
        sortSubProperties()
        properties.sortUsingDescriptors(getSortDescriptors())
    }

    func sortSubProperties() {
        for obj in properties {
            if let prop = obj as? Properties {
                prop.sortSubProperties()
            }
        }
    }

    func selectProperty(property:Properties) {
        for obj in properties {
            if let prop = obj as? Properties {
                if prop == property {
                    prop.isSelected = true
                }else{
                    prop.isSelected = false
                }
            }
        }
    }

    func selectSubProperty(subProperty:SubProperties) {
        if subProperty.isSelected {
            subProperty.isSelected = false
            subProperty.parentProperty?.selectedItemsCount -= 1
            if subProperty.parentProperty?.selectedItemsCount < 0 {
                subProperty.parentProperty?.selectedItemsCount = 0
            }
        }else{
            subProperty.isSelected = true
            subProperty.parentProperty?.selectedItemsCount += 1
        }
    }
}


//MARK:- ------------------
class Properties: NSObject {
    //MARK:- Variables
    var name = ""
    var selectedItemsCount = 0
    var isSelected = false
    var subProperties = NSMutableArray()

    //MARK:- Additional methods
    func getSortDescriptors() -> [NSSortDescriptor] {
        let sortDescriptor_name = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor_isSelected = NSSortDescriptor(key: "isSelected", ascending: false)
        return [sortDescriptor_isSelected, sortDescriptor_name]
    }
    func sortSubProperties() {
        subProperties.sortUsingDescriptors(getSortDescriptors())
    }
}


//MARK:- ------------------
class SubProperties: NSObject {
    //MARK:- Variables
    var name = ""
    var isSelected = false
    var parentProperty:Properties?
}