
//
//  TemplatesModel.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 24/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
enum ObjectType:Int {
    case template, track, count
}
class TemplatesModel: NSObject {

    //MARK:- Variables
    var objectType = ObjectType.template
    var templateId:String?
    var name:String?
    var details = ""
    var htmldetails = ""
    var status = ""
    var templateImageUrl = ""
    var createdBy = ""
    var createDate = 0
    var key:String?
    var rating = 0.0
    var commentsCount = 0
    var activeTrackCount = 0
    var phases = NSMutableArray()
    var isFollowing = false
    var followersCount = 0
    var resources = NSMutableArray()

    //MARK: Additional for tracks
    var trackId:String?
    var members = NSMutableArray()
    var trackImageUrl = ""
}

//MARK:- Additional methods
extension TemplatesModel{

    func getCreateTrackDict(_ trackName:String?, array:NSMutableArray) -> [String:AnyObject] {
        var dict:[String:AnyObject] = [:]
        dict["templateID"] = templateId as AnyObject?? ?? "" as AnyObject?
        dict["teamName"] = trackName as AnyObject?? ?? name as AnyObject?
        var arrOfMembers:[[String: String]] = []
        for obj in array {
            if let id = obj as? String {
                arrOfMembers.append(["emailOrPhone":id , "isdCode": ""])
            }
        }
        dict["members"] = arrOfMembers as AnyObject?
        return dict
    }

    func isMemberOfTemplate(_ id:String) -> Bool{
        if let _ = self.members.filtered(using: NSPredicate(format: "userID = %@", id)).first {
            return true
        }
        return false
    }
    
    func getInviteMemberDict(_ array:NSMutableArray) -> [String:AnyObject] {
        var dict:[String:AnyObject] = [:]
        dict["trackID"] = trackId as AnyObject?? ?? "" as AnyObject?
        var arrOfMembers:[[String: String]] = []
        for obj in array {
            if let id = obj as? String {
                arrOfMembers.append(["emailOrPhone":id])
            }
        }
        dict["members"] = arrOfMembers as AnyObject?
        return dict
    }
    func getFollowingDict(_ followValue:Bool) -> [String:AnyObject] {
        var dict:[String:AnyObject] = [:]
        dict["templateId"] = templateId as AnyObject?? ?? "" as AnyObject?
        dict["follow"] = followValue as AnyObject?
        return dict
    }

    func updateFollowers(_ dict:AnyObject?) {
        self.followersCount = dict?["followerCount"] as? Int ?? 0
        self.isFollowing = dict?["currentUserFollower"] as? Bool ?? false
    }

    func updateRating(_ response:AnyObject?) {
        if let ratingVal  = response?["rating"] as? String {
            rating = Double(ratingVal) ?? 0.0
        }
    }

    class func getPayloadDict(_ cursor:String, query:String = "" ,orderBy:String = "" , filterByType:NSArray = []) -> [String:AnyObject] {
        return ["cursor":cursor as AnyObject, "pageSize": 20 as AnyObject, "query": query as AnyObject , "orderBy":orderBy as AnyObject , "filterByType":filterByType]
    }

    class func getSearchUserDict(_ cursor:String, query:String = "") -> [String:AnyObject] {
        return ["cursor":cursor as AnyObject, "pageSize": 100 as AnyObject, "query": query as AnyObject]
    }
    class func getTemplateResponseArray(_ dict:AnyObject) -> NSArray {
        return dict["templateResultSet"] as? NSArray ?? []
    }

    class func getTrackResponseArray(_ dict:AnyObject) -> NSArray {
        return dict["myTracksResultSet"] as? NSArray ?? []
    }

    class func getCursor(_ dict:AnyObject) -> String? {
        return dict["cursor"] as? String
    }

    class func getTotalObjectsCount(_ dict:AnyObject) -> Int {
        return dict["totalCount"] as? Int ?? 0
    }

    class func getTemplateObj(_ dict:AnyObject) -> TemplatesModel {
        let model = TemplatesModel()
        updateTemplateObj(model, dict: dict)
        return model
    }

    class func getTrackObj(_ dict:AnyObject) -> TemplatesModel {
        let model = TemplatesModel()
        updateTrackObj(model, dict: dict)
        return model
    }

    class func updateTemplateObj(_ obj:TemplatesModel, dict:AnyObject) {

        obj.objectType = ObjectType.template
        obj.templateId = dict["id"] as? String
        obj.name = dict["name"] as? String
        obj.details = dict["descriptionText"] as? String ?? obj.details
        obj.htmldetails = dict["description"] as? String ?? obj.htmldetails
        obj.templateImageUrl = dict["profileURL"] as? String ?? obj.templateImageUrl
        obj.createdBy = dict["createdBy"] as? String ?? obj.createdBy
        obj.createDate = dict["createdDate"] as? Int ?? obj.createDate
        obj.rating = dict["rating"] as? Double ?? 0
        obj.commentsCount = dict["reviewCount"] as? Int ?? 0
        obj.activeTrackCount = dict["activeTracks"] as? Int ?? 0
        obj.followersCount = dict["followerCount"] as? Int ?? 0
        obj.isFollowing = dict["currentUserFollower"] as? Bool ?? false

        addPhases(dict, toModel: obj)
        addResources(dict, toModel: obj)
    }

    class func updateTrackObj(_ obj:TemplatesModel, dict:AnyObject) {

        obj.objectType = ObjectType.track
        obj.trackId = dict["id"] as? String
        obj.templateId = dict["templateId"] as? String
        obj.name = dict["name"] as? String
        obj.details = dict["descriptionText"] as? String ?? ""
        obj.htmldetails = dict["description"] as? String ?? ""
        obj.templateImageUrl = dict["templateURL"] as? String ?? obj.templateImageUrl
        obj.trackImageUrl = dict["trackURL"] as? String ?? ""
        obj.createdBy = dict["createdBy"] as? String ?? ""
        obj.createDate = dict["createdDate"] as? Int ?? 0
        obj.rating = dict["rating"] as? Double ?? 0
        obj.commentsCount = dict["commentCount"] as? Int ?? 0
        obj.followersCount = dict["followerCount"] as? Int ?? 0
        obj.isFollowing = dict["currentUserFollower"] as? Bool ?? false
        obj.key = dict["key"] as? String
        obj.status = dict["status"] as? String ?? ""
        addPhases(dict, toModel: obj)
        addMembers(dict, toModel: obj)
        addResources(dict, toModel: obj)
    }

    class func addResources(_ dict:AnyObject, toModel:TemplatesModel) {
        toModel.resources = NSMutableArray()
        if let arr = dict["resources"] as? NSArray{
            for resourceObject in arr {
                if let resourceDict = resourceObject as? [String:AnyObject]{
                    toModel.resources.add(Resources.getResourceUsingObj(resourceDict as AnyObject))
                }
            }
        }
    }

    class func addMembers(_ dict:AnyObject, toModel:TemplatesModel) {
        toModel.members = NSMutableArray()
        if let arr = dict["members"] as? NSArray{
            for userObject in arr {
                if let userDict = userObject as? [String:AnyObject]{
                    toModel.members.add(UserModel.getUserObject(userDict))
                }
            }
        }
    }

    class func addPhases(_ dict:AnyObject, toModel:TemplatesModel) {

        toModel.phases = NSMutableArray()
        let obj = toModel.objectType == .template ? dict["details"] : dict["phasesAndTasks"]
        if let phases = obj as? NSArray {
            for phase in phases {
                let phaseObj = PhasesModel.getPhaseUsingObj(phase as AnyObject)
                phaseObj.parentTemplate = toModel
                toModel.phases.add(phaseObj)
            }
            let sortDesc = NSSortDescriptor(key: "orderIndex", ascending: true)
            toModel.phases.sort(using: [sortDesc])
        }
    }
}
