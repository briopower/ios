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
    var taskId:String?
    var postIds:[Int] = []
    var orderIndex = 0
    var taskName = ""
    var prompt = ""
    var key = ""
    var rating = 0.0
    var commentsCount = 0
    var parentPhase = PhasesModel()

    //MARK: Additional for tracks
    var status = ""
    var templateTaskId:String?

}

//MARK:- Additional methods
extension TasksModel{
   class func getDictForRating(key:String, rating:CGFloat) -> [String : AnyObject] {
    let val = Double(Int(rating * 10))
        return ["key":key, "rating":"\(Double(val/10))"];
    }

    class func getTasksUsingObj(dict:AnyObject) -> TasksModel {
        let model = TasksModel()
        model.taskId = dict["id"] as? String
        model.postIds = dict["postIds"] as? [Int] ?? []
        model.orderIndex = dict["orderIndex"] as? Int ?? 0
        model.taskName = dict["name"] as? String ?? ""
        model.prompt = dict["prompt"] as? String ?? ""
        model.key = dict["key"] as? String ?? ""
        model.rating = dict["rating"] as? Double ?? 0
        model.commentsCount = dict["comments"] as? Int ?? 0
        model.templateTaskId = dict["templateTaskId"] as? String
        model.status = dict["status"] as? String ?? ""
        return model
    }
}
