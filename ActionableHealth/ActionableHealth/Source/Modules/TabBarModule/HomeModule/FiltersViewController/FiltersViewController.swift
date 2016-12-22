//
//  FiltersViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class FiltersViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var propertiesTblView: PropertiesTableView!
    @IBOutlet weak var subPropertiesTblView: SubPropertiesTableView!
    
    //MARK:- Variables
    var filterObj:FilterByObject!
    var delegate:HomeViewController?
    var selectedFilters = []
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Additional methods
extension FiltersViewController{
    func setupView() {
        if filterObj == nil {
            filterObj = getFilterByObject()
        }
        
        filterObj.sortProperties()
        if let prop = filterObj.properties.firstObject as? Properties {
            prop.isSelected = true
            subPropertiesTblView.dataArray = prop.subProperties
            for obj in prop.subProperties {
                if let localobj = obj as? SubProperties{
                    for names in selectedFilters {
                        if localobj.name == String(names){
                            localobj.isSelected = true
                            prop.selectedItemsCount = prop.selectedItemsCount+1
                        }
                    }
                }
            }
        }

        propertiesTblView.propertiesTableViewDelegate = self
        propertiesTblView.dataArray = filterObj.properties
        propertiesTblView.setupTableView()

        subPropertiesTblView.subPropertiesTableViewDelegate = self
        subPropertiesTblView.setupTableView()
    }

    func getFilterByObject() -> FilterByObject {
        let filterObj = FilterByObject()

//        let prop1 = Properties()
//        prop1.name = "Category"
//
//        let subProperty1 = SubProperties()
//        subProperty1.name = "Exercise"
//        subProperty1.parentProperty = prop1
//        prop1.subProperties.addObject(subProperty1)
//
//        let subProperty2 = SubProperties()
//        subProperty2.name = "Fitness"
//        subProperty2.parentProperty = prop1
//        prop1.subProperties.addObject(subProperty2)
//
//        let subProperty3 = SubProperties()
//        subProperty3.name = "Diet"
//        subProperty3.parentProperty = prop1
//        prop1.subProperties.addObject(subProperty3)
//
//        let subProperty4 = SubProperties()
//        subProperty4.name = "Food"
//        subProperty4.parentProperty = prop1
//        prop1.subProperties.addObject(subProperty4)
//
//        filterObj.properties.addObject(prop1)


        let prop2 = Properties()
        prop2.name = "Type"

        let subProperty12 = SubProperties()
        subProperty12.name = "Yoga"
        subProperty12.parentProperty = prop2
        prop2.subProperties.addObject(subProperty12)

        let subProperty22 = SubProperties()
        subProperty22.name = "Training"
        subProperty22.parentProperty = prop2
        prop2.subProperties.addObject(subProperty22)

        let subProperty32 = SubProperties()
        subProperty32.name = "Aerobics"
        subProperty32.parentProperty = prop2
        prop2.subProperties.addObject(subProperty32)

        let subProperty42 = SubProperties()
        subProperty42.name = "Karate"
        subProperty42.parentProperty = prop2
        prop2.subProperties.addObject(subProperty42)

        let subProperty52 = SubProperties()
        subProperty52.name = "HIIT"
        subProperty52.parentProperty = prop2
        prop2.subProperties.addObject(subProperty52)

        filterObj.properties.addObject(prop2)

        return filterObj
    }
}

//MARK:- PropertiesTableViewDelegate
extension FiltersViewController:PropertiesTableViewDelegate{
    func propertySelected(selectedProperty: Properties, index: Int) {
        filterObj.selectProperty(selectedProperty)
        selectedProperty.sortSubProperties()
        subPropertiesTblView.dataArray = selectedProperty.subProperties
        propertiesTblView.reloadData()
        subPropertiesTblView.reloadData()
    }
}

//MARK:- SubPropertiesTableViewDelagate
extension FiltersViewController: SubPropertiesTableViewDelagate{
    func subPropertySelected(selectedSubProperty: SubProperties, index: Int) {
        filterObj.selectSubProperty(selectedSubProperty)
        propertiesTblView.reloadData()
        subPropertiesTblView.reloadData()
    }
}
//MARK:- Actions
extension FiltersViewController{
    @IBAction func crossButtonActions(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func clearButtonActions(sender: UIButton) {
        filterObj.deselectAllSubProperties()
        propertiesTblView.reloadData()
        subPropertiesTblView.reloadData()
    }
    @IBAction func applyButtonActions(sender: UIButton) {
        if let obj = delegate{
            obj.filterArray = filterObj.getAllSelectedSubproperties()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
