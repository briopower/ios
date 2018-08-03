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
    var phsaeId:String?
    var postIds:[Int] = []
    var orderIndex = 0
    var phaseName = ""
    var prompt = ""
    var key = ""
    var rating = 0.0
    var commentsCount = 0
    var tasks = NSMutableArray()
    var parentTemplate = TemplatesModel()
    var details = ""
    var resources = NSMutableArray()

    //MARK: Additional for tracks
    var status = ""
    var templatePhaseId:String?
}


//MARK:- Additional methods
extension PhasesModel{

    class func getPhaseUsingObj(_ dict:AnyObject) -> PhasesModel {
        let model = PhasesModel()
        updateObj(model, dict:dict)
        return model
    }

    class func updateObj(_ model:PhasesModel, dict:AnyObject) {
        model.phsaeId = dict["id"] as? String
        model.postIds = dict["postIds"] as? [Int] ?? []
        model.orderIndex = dict["orderIndex"] as? Int ?? 0
        model.phaseName = dict["name"] as? String ?? ""
        model.prompt = dict["prompt"] as? String ?? ""
        model.key = dict["key"] as? String ?? ""
        model.rating = dict["rating"] as? Double ?? 0
        model.commentsCount = dict["commentCount"] as? Int ?? 0
        model.templatePhaseId = dict["templatePhaseId"] as? String
        model.status = dict["status"] as? String ?? ""
        model.details = dict["description"] as? String ?? ""

        addTasks(dict, model: model)
        addResources(dict, toModel: model)
    }

    class func addTasks(_ dict:AnyObject, model:PhasesModel) {
        model.tasks = NSMutableArray()
        if let tasks = dict["tasks"] as? NSArray {
            for temp in tasks {
                let task = TasksModel.getTasksUsingObj(temp as AnyObject)
                task.parentPhase = model
                model.tasks.add(task)
            }
            let sortDesc = NSSortDescriptor(key: "orderIndex", ascending: true)
            model.tasks.sort(using: [sortDesc])
        }
    }

    class func addResources(_ dict:AnyObject, toModel:PhasesModel) {
        toModel.resources = NSMutableArray()
        if let arr = dict["resources"] as? NSArray{
            for resourceObject in arr {
                if let resourceDict = resourceObject as? [String:AnyObject]{
                    toModel.resources.add(Resources.getResourceUsingObj(resourceDict as AnyObject))
                }
            }
        }
    }
}
