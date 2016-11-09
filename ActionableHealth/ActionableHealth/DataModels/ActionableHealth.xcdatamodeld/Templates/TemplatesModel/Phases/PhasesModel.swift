//
//  PhasesModel.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 26/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class PhasesModel: NSObject {

    //MARK:- Variables
    var phsaeId = ""
    var postIds:[Int] = []
    var orderIndex = 0
    var phaseName = ""
    var prompt = ""
    var key = ""
    var rating = 0.0
    var commentsCount = 0
    var tasks = NSMutableArray()
    var parentTemplate = TemplatesModel()
}


//MARK:- Additional methods
extension PhasesModel{

    class func getPhaseUsingObj(dict:AnyObject) -> PhasesModel {
        let model = PhasesModel()
        model.phsaeId = dict["id"] as? String ?? ""
        model.postIds = dict["postIds"] as? [Int] ?? []
        model.orderIndex = dict["orderIndex"] as? Int ?? 0
        model.phaseName = dict["name"] as? String ?? ""
        model.prompt = dict["prompt"] as? String ?? ""
        model.key = dict["key"] as? String ?? ""
        model.rating = dict["rating"] as? Double ?? 0
        model.commentsCount = dict["comments"] as? Int ?? 0

        if let tasks = dict["tasks"] as? NSMutableArray {
            for temp in tasks {
                let task = TasksModel.getTasksUsingObj(temp)
                task.parentPhase = model
                model.tasks.addObject(task)
            }
            let sortDesc = NSSortDescriptor(key: "orderIndex", ascending: true)
            model.tasks.sortUsingDescriptors([sortDesc])
        }
        return model
    }
}