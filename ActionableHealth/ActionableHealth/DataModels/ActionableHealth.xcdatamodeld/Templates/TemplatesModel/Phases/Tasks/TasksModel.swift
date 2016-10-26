//
//  TasksModel.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 26/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TasksModel: NSObject {

    //MARK:- Variables
    var taskId = ""
    var postIds = ""
    var orderIndex = 0
    var taskName = ""
    var prompt = ""
    var key = ""
    var parentPhase = PhasesModel()
}

//MARK:- Additional methods
extension TasksModel{
    class func getTasksUsingObj(dict:AnyObject) -> TasksModel {
        let model = TasksModel()
        model.taskId = dict["id"] as? String ?? ""
        model.postIds = dict["postIds"] as? String ?? ""
        model.orderIndex = dict["orderIndex"] as? Int ?? 0
        model.taskName = dict["name"] as? String ?? ""
        model.prompt = dict["prompt"] as? String ?? ""
        model.key = dict["key"] as? String ?? ""
        return model
    }
}