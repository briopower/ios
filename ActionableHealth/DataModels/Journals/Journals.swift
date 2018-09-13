//
//  Journals.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/16/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import Foundation

class JournalsManager {
    
    var cursor: String?
    var totalCount: String?
    var journalResultSet: [Journal]?
    var returnedCount: String?
    
    
    init() {
        cursor = ""
        totalCount = "0"
        returnedCount = "0"
        journalResultSet = [Journal]()
    }
    class func initWithDict(dict: [String : Any])-> JournalsManager{
        let journalsManager = JournalsManager()
        journalsManager.cursor = dict["cursor"] as? String
        journalsManager.totalCount = dict["totalCount"] as? String
        journalsManager.returnedCount = dict["returnedCount"] as? String
        if let resultSet = dict["journalResultSet"] as? [[String : Any]]{
            journalsManager.journalResultSet = Journal.getJournalsArray(array: resultSet)
        }
        return journalsManager
    }
    
}

class Journal {
    var id: String?
    var userId: String?
    var trackId: String?
    var description: String?
    var createdDate: Date?
    var isSelcetedForDelete = false
    init() {
        id = ""
        userId = ""
        trackId = ""
        description = ""
        createdDate = Date()
    }
    class func initWithDict(dict: [String : Any])-> Journal{
        let journal = Journal()
        journal.id = dict["id"] as? String
        journal.description = dict["description"] as? String
        journal.createdDate = Date.dateWithTimeIntervalInMilliSecs((dict["createdDate"] as? NSNumber)?.doubleValue ?? 0)
        journal.trackId = dict["trackId"] as? String
        journal.userId = dict["userId"] as? String
        return journal
    }
    class func getJournalsArray(array: [[String : Any]]) -> [Journal] {
        var journalsArray = [Journal]()
        for element in array{
            journalsArray.append(Journal.initWithDict(dict: element))
        }
        return journalsArray
    }
}
