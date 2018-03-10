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
    var progress = 0.0
    var commentsCount = 0
    var parentPhase = PhasesModel()
    var startedDate = 0.0
    var pausedDate = 0.0
    var completedDate = 0.0
    var remainingTimeInMillis = 0.0
    var details = ""
    var resources = NSMutableArray()

    //MARK: Additional for tracks
    var status = ""
    var templateTaskId:String?
}

//MARK:- Additional methods
extension TasksModel{

    func updateRating(response:AnyObject?) {
        if let ratingVal  = response?["rating"] as? String {
            rating = Double(ratingVal) ?? 0.0
        }
    }

    class func getDictForRating(key:String, rating:CGFloat) -> [String : AnyObject] {
        let val = Double(Int(rating * 10))
        return ["key":key, "rating":"\(Double(val/10))"];
    }

    class func getDictForStatus(key:String, status:String) -> [String : AnyObject] {
        return ["key":key, "status":status];
    }
    class func getDictForProgress(key:String, progress:String) -> [String : AnyObject] {
        return ["key":key, "progress":progress];
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
        model.progress = (dict["progress"] as? Double ?? 0) * 100
        model.commentsCount = dict["commentCount"] as? Int ?? 0
        model.templateTaskId = dict["templateTaskId"] as? String
        model.status = dict["status"] as? String ?? ""
        model.startedDate = dict["startedDate"] as? Double ?? 0
        model.pausedDate = dict["pausedDate"] as? Double ?? 0
        model.completedDate = dict["completedDate"] as? Double ?? 0
        model.remainingTimeInMillis = dict["remainingTimeInMillis"] as? Double ?? 0
        model.details = dict["description"] as? String ?? ""

        addResources(dict, toModel: model)
        return model
    }

    class func addResources(dict:AnyObject, toModel:TasksModel) {
        toModel.resources = NSMutableArray()
        if let arr = dict["resources"] as? NSArray{
            for resourceObject in arr {
                if let resourceDict = resourceObject as? [String:AnyObject]{
                    toModel.resources.addObject(Resources.getResourceUsingObj(resourceDict))
                }
            }
        }
    }
}
