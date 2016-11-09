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
    var postIds:[Int] = []
    var orderIndex = 0
    var taskName = ""
    var prompt = ""
    var key = ""
    var rating = 0.0
    var commentsCount = 0
    var parentPhase = PhasesModel()
}

//MARK:- Additional methods
extension TasksModel{
    class func getTasksUsingObj(dict:AnyObject) -> TasksModel {
        let model = TasksModel()
        model.taskId = dict["id"] as? String ?? ""
        model.postIds = dict["postIds"] as? [Int] ?? []
        model.orderIndex = dict["orderIndex"] as? Int ?? 0
        model.taskName = dict["name"] as? String ?? ""
        model.prompt = dict["prompt"] as? String ?? ""
        model.key = dict["key"] as? String ?? ""
        model.rating = dict["rating"] as? Double ?? 0
        model.commentsCount = dict["comments"] as? Int ?? 0
        return model
    }
}