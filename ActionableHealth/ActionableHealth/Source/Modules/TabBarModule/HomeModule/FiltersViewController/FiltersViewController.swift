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
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    //MARK:- Variables
    var filterObj:FilterByObject!
    weak var delegate:HomeViewController?
    var selectedFilters: [Any] = []

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
                    if localobj.name == String(describing: names){
                        localobj.isSelected = true
                    }
                }
            }
        }
        subPropertiesTblView.subPropertiesTableViewDelegate = self
        subPropertiesTblView.dataArray = filterObj.subProperties
        subPropertiesTblView.setupTableView()
        applyButton.isEnabled = false
        clearButton.isEnabled = filterObj.getAllSelectedSubproperties().count != 0
    }
    func getFilterObject() -> FilterByObject {
        
        let filterObj = FilterByObject()
        
        let subProperty1 = SubProperties()
        subProperty1.name = "Yoga"
        filterObj.subProperties.add(subProperty1)
        
        let subProperty2 = SubProperties()
        subProperty2.name = "Training"
        filterObj.subProperties.add(subProperty2)
        
        let subProperty3 = SubProperties()
        subProperty3.name = "Aerobics"
        filterObj.subProperties.add(subProperty3)
        
        let subProperty4 = SubProperties()
        subProperty4.name = "Karate"
        filterObj.subProperties.add(subProperty4)
        
        let subProperty5 = SubProperties()
        subProperty5.name = "HIIT"
        filterObj.subProperties.add(subProperty5)
        return filterObj
    }
}

//MARK:- SubPropertiesTableViewDelagate
extension FiltersViewController: SubPropertiesTableViewDelagate{
    func subPropertySelected(_ selectedSubProperty: SubProperties, index: Int) {
        filterObj.selectSubProperty(selectedSubProperty)
        subPropertiesTblView.reloadData()
        applyButton.isEnabled = true
        clearButton.isEnabled = true
    }
}
//MARK:- Actions
extension FiltersViewController{
    @IBAction func crossButtonActions(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clearButtonActions(_ sender: UIButton) {
        filterObj.deselectAllSubProperties()
        subPropertiesTblView.reloadData()
        applyButton.isEnabled = true
    }
    @IBAction func applyButtonActions(_ sender: UIButton) {
        if let obj = delegate{
            obj.filterArray = filterObj.getAllSelectedSubproperties() as! [Any]
        }
        self.dismiss(animated: true, completion: nil)
    }
}
