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
            filterObj = getFilterObject()
        }
        for obj in filterObj.subProperties {
            if let localobj = obj as? SubProperties{
                for names in selectedFilters {
                    if localobj.name == String(names){
                        localobj.isSelected = true
                    }
                }
            }
        }
        subPropertiesTblView.subPropertiesTableViewDelegate = self
        subPropertiesTblView.dataArray = filterObj.subProperties
        subPropertiesTblView.setupTableView()
    }

    func getFilterObject() -> FilterByObject {
        
        let filterObj = FilterByObject()
        
        let subProperty1 = SubProperties()
        subProperty1.name = "Yoga"
        filterObj.subProperties.addObject(subProperty1)
        
        let subProperty2 = SubProperties()
        subProperty2.name = "Training"
        filterObj.subProperties.addObject(subProperty2)
        
        let subProperty3 = SubProperties()
        subProperty3.name = "Aerobics"
        filterObj.subProperties.addObject(subProperty3)
        
        let subProperty4 = SubProperties()
        subProperty4.name = "Karate"
        filterObj.subProperties.addObject(subProperty4)
        
        let subProperty5 = SubProperties()
        subProperty5.name = "HIIT"
        filterObj.subProperties.addObject(subProperty5)
        return filterObj
    }
}

//MARK:- SubPropertiesTableViewDelagate
extension FiltersViewController: SubPropertiesTableViewDelagate{
    func subPropertySelected(selectedSubProperty: SubProperties, index: Int) {
        filterObj.selectSubProperty(selectedSubProperty)
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
        subPropertiesTblView.reloadData()
    }
    @IBAction func applyButtonActions(sender: UIButton) {
        if let obj = delegate{
            obj.filterArray = filterObj.getAllSelectedSubproperties()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
