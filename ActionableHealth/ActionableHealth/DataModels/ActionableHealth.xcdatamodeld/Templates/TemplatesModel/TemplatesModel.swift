//
//  TemplatesModel.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 24/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

class TemplatesModel: NSObject {

    //MARK:- Variables
    var templateId = ""
    var name = ""
    var type = ""
    var code = ""
    var details = ""
    var status = ""
    var url = ""
    var imageUrl = ""
    var createdBy = ""
    var fileName = ""
    var createDate = 0
    var sharedWith = []
    var key = ""

}

//MARK:- Additional methods
extension TemplatesModel{

    class func getPayloadDict(withShift:Int) -> [String:AnyObject] {
        if withShift == 0 {
            return ["cursor":"", "pageSize": 20, "query": ""]
        }
        return ["cursor":"\(withShift)", "pageSize": 20, "query": ""]
    }

    class func getResponseArray(dict:AnyObject) -> NSArray {
        return dict["templateResultSet"] as? NSArray ?? []
    }

    class func getNextUrl(dict:AnyObject) -> String? {
        return dict["cursor"] as? String
    }

    class func getTotalObjectsCount(dict:AnyObject) -> Int {
        return dict["totalCount"] as? Int ?? 0
    }
    
    class func getTemplateObj(dict:AnyObject) -> TemplatesModel {
        let model = TemplatesModel()
        updateObj(model, dict: dict)
        return model
    }

    class func updateObj(obj:TemplatesModel, dict:AnyObject) {
        obj.templateId = dict["id"] as? String ?? ""
        obj.name = dict["name"] as? String ?? ""
        obj.type = dict["type"] as? String ?? ""
        obj.code = dict["code"] as? String ?? ""
        obj.details = dict["description"] as? String ?? ""
        obj.status = dict["status"] as? String ?? ""
        obj.url = dict["url"] as? String ?? ""
        obj.imageUrl = dict["profileURL"] as? String ?? ""
        obj.createdBy = dict["createdBy"] as? String ?? ""
        obj.fileName = dict["fileName"] as? String ?? ""
        obj.createDate = dict["createdDate"] as? Int ?? 0
        obj.sharedWith = dict["sharedWith"] as? NSArray ?? []
        obj.key = dict["key"] as? String ?? ""
    }
}