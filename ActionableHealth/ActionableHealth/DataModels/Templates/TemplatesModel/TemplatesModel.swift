//
//  TemplatesModel.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 24/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum ObjectType:Int {
    case Template, Track, Count
}
class TemplatesModel: NSObject {

    //MARK:- Variables
    var objectType = ObjectType.Template
    var templateId:String?
    var name = ""
    var type = ""
    var code = ""
    var details = ""
    var status = ""
    var url = ""
    var templateImageUrl = ""
    var createdBy = ""
    var fileName = ""
    var createDate = 0
    var sharedWith = []
    var key:String?
    var rating = 0.0
    var commentsCount = 0
    var activeTrackCount = 0
    var phases = NSMutableArray()

    //MARK: Additional for tracks
    var trackId:String?
    var members = NSMutableArray()
    var trackImageUrl = ""
    var blobKey:String?
}

//MARK:- Additional methods
extension TemplatesModel{

    func getCreateTrackDict(array:NSMutableArray) -> [String:AnyObject] {
        var dict:[String:AnyObject] = [:]
        dict["templateID"] = templateId ?? ""
        dict["teamName"] = name
        var arrOfMembers:[[String: String]] = []
        for obj in array {
            if let id = obj as? String {
                arrOfMembers.append(["emailOrPhone":id])
            }
        }
        dict["members"] = arrOfMembers
        return dict
    }

    func getInviteMemberDict(array:NSMutableArray) -> [String:AnyObject] {
        var dict:[String:AnyObject] = [:]
        dict["trackID"] = trackId ?? ""
        var arrOfMembers:[[String: String]] = []
        for obj in array {
            if let id = obj as? String {
                arrOfMembers.append(["emailOrPhone":id])
            }
        }
        dict["members"] = arrOfMembers
        return dict
    }
    class func getPayloadDict(cursor:String, query:String = "") -> [String:AnyObject] {
        return ["cursor":cursor, "pageSize": 20, "query": query]
    }

    class func getTemplateResponseArray(dict:AnyObject) -> NSArray {
        return dict["templateResultSet"] as? NSArray ?? []
    }

    class func getTrackResponseArray(dict:AnyObject) -> NSArray {
        return dict["myTracksResultSet"] as? NSArray ?? []
    }

    class func getCursor(dict:AnyObject) -> String? {
        return dict["cursor"] as? String
    }

    class func getTotalObjectsCount(dict:AnyObject) -> Int {
        return dict["totalCount"] as? Int ?? 0
    }

    class func getTemplateObj(dict:AnyObject) -> TemplatesModel {
        let model = TemplatesModel()
        updateTemplateObj(model, dict: dict)
        return model
    }

    class func getTrackObj(dict:AnyObject) -> TemplatesModel {
        let model = TemplatesModel()
        updateTrackObj(model, dict: dict)
        return model
    }

    class func updateTemplateObj(obj:TemplatesModel, dict:AnyObject) {
        obj.objectType = ObjectType.Template
        obj.templateId = dict["id"] as? String
        obj.name = dict["name"] as? String ?? ""
        obj.type = dict["type"] as? String ?? ""
        obj.code = dict["code"] as? String ?? ""
        obj.details = dict["descriptionText"] as? String ?? ""
        obj.status = dict["status"] as? String ?? ""
        obj.url = dict["url"] as? String ?? ""
        obj.templateImageUrl = dict["profileURL"] as? String ?? ""
        obj.createdBy = dict["createdBy"] as? String ?? ""
        obj.fileName = dict["fileName"] as? String ?? ""
        obj.createDate = dict["createdDate"] as? Int ?? 0
        obj.sharedWith = dict["sharedWith"] as? NSArray ?? []
        obj.key = dict["key"] as? String
        obj.rating = dict["rating"] as? Double ?? 0
        obj.commentsCount = dict["comments"] as? Int ?? 0
        obj.activeTrackCount = dict["activeTracks"] as? Int ?? 0
    }

    class func updateTrackObj(obj:TemplatesModel, dict:AnyObject) {
        obj.objectType = ObjectType.Track
        obj.trackId = dict["id"] as? String
        obj.templateId = dict["templateId"] as? String
        obj.name = dict["name"] as? String ?? ""
        obj.details = dict["description"] as? String ?? ""
        obj.templateImageUrl = dict["templateURL"] as? String ?? ""
        obj.trackImageUrl = dict["trackURL"] as? String ?? ""
        obj.createdBy = dict["createdBy"] as? String ?? ""
        obj.fileName = dict["fileName"] as? String ?? ""
        obj.createDate = dict["createdDate"] as? Int ?? 0
        obj.rating = dict["rating"] as? Double ?? 0
        obj.commentsCount = dict["comments"] as? Int ?? 0
        obj.members = NSMutableArray(array: dict["members"] as? NSArray ?? [])
        obj.blobKey = dict["blobKey"] as? String
        obj.key = dict["key"] as? String

    }

    class func addPhases(dict:AnyObject, toModel:TemplatesModel) {
        toModel.key = dict["key"] as? String ?? toModel.key
        
        toModel.phases = NSMutableArray()
        let obj = toModel.objectType == .Template ? dict["details"] : dict["phasesAndTasks"]
        if let phases = obj as? NSArray {
            for phase in phases {
                let phaseObj = PhasesModel.getPhaseUsingObj(phase)
                phaseObj.parentTemplate = toModel
                toModel.phases.addObject(phaseObj)
            }
            let sortDesc = NSSortDescriptor(key: "orderIndex", ascending: true)
            toModel.phases.sortUsingDescriptors([sortDesc])
        }
    }
}
