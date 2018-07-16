//
//  Messages+CoreDataClass.swift
//
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData

enum MessageStatus:String {
    case Sent, Recieved, Read
}

@objc(Messages)

//MARK:- Public Methods
open class Messages: NSManagedObject {

    class func saveMessageFor(_ key:String, value:[String:AnyObject]){
        if let prntCxt = AppDelegate.getAppDelegateObject()?.managedObjectContext, let bgCxt = AppDelegate.getAppDelegateObject()?.bgManagedObjectContext {

            let message = CoreDataOperationsClass.fetchObjectsOfClassWithName("Messages", predicate: NSPredicate(format: "messageId = %@", key), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: bgCxt) as? [Messages]

            if message?.count ?? 0 == 0 {
                bgCxt.perform({
                    insertMessageInDB(key, value: value, context: bgCxt)
                    do{
                        try bgCxt.save()
                        prntCxt.perform({
                            do{
                                try prntCxt.save()
                            }catch{
                                debugPrint("Error saving data")
                            }
                        })
                    }catch{
                        debugPrint("Error saving data")
                    }
                })
            }else{
                debugPrint("Message already exists")
            }
        }
    }

    fileprivate class func insertMessageInDB(_ key:String, value:[String:AnyObject], context:NSManagedObjectContext) {
        debugPrint("Recieved New Message")
        if let fromId = value["from"] as? String {
            let messageObject = Messages(entity: NSEntityDescription.entity(forEntityName: String(describing: Messages), in: context)!, insertInto: context)

            messageObject.messageId = key
            messageObject.key = value["data"]?["key"] as? String
            messageObject.message = value["data"]?["message"] as? String
            messageObject.type = value["data"]?["type"] as? String
            messageObject.priority = value["priority"] as? String
            messageObject.timestamp = value["timeStamp"] as? NSNumber
            messageObject.msgDate = Date.dateWithTimeIntervalInMilliSecs((messageObject.timestamp ?? 0).doubleValue).startOfDay()

            if fromId == UserDefaults.getUserId() {
                if let toId = messageObject.key {
                    if let person = Person.getPersonWith(toId, contextRef: context) {
                        person.markAllAsRead()
                        messageObject.person = person
                    }
                }
                messageObject.status = MessageStatus.Sent.rawValue
            }else{
                messageObject.status = MessageStatus.Recieved.rawValue
                if let person = Person.getPersonWith(fromId, contextRef: context) {
                    messageObject.person = person
                }
            }
            messageObject.person?.lastTrack = (value["lastTrackName"] as? String)?.getValidObject()
            messageObject.person?.lastMessage = messageObject
            messageObject.person?.addToMessages(messageObject)
        }
    }
}
