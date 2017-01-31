//
//  Person+CoreDataClass.swift
//
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData

//MARK:- Public Methods
public class Person: NSManagedObject {
    func getUnreadMessageCount() -> Int {
        return messages?.filteredSetUsingPredicate(NSPredicate(format: "self.status = %@", MessageStatus.Recieved.rawValue)).count ?? 0
    }

    func markAllAsRead() {
        
        if let set = messages?.filteredSetUsingPredicate(NSPredicate(format: "self.status = %@", MessageStatus.Recieved.rawValue)) {
            if let arr = Array(set) as? [Messages]{
                for msg in arr {
                    msg.status = MessageStatus.Read.rawValue
                }
            }
        }
    }

    func updateProfileImage() {
        NetworkClass.sendRequest(URL: "\(Constants.URLs.profileImageURL)\(personId ?? "")", RequestType: .GET) {
            (status, responseObj, error, statusCode) in
            if status, let imageUrl = responseObj?["profileURL"] as? String{
                self.personImage = imageUrl
            }
        }
    }

    class func getPersonWith(id:String, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) -> Person? {

        if let context = contextRef{

            var personObj:Person?
            let presonArr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(Person), predicate: NSPredicate(format: "personId = %@", id), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: context) as? [Person]

            if let temp = presonArr?.first{
                personObj = temp
                for obj in presonArr ?? [] {
                    if obj != personObj {
                        context.deleteObject(obj)
                    }
                }
            }else{
                personObj = Person(entity: NSEntityDescription.entityForName(String(Person), inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
            }
            personObj?.personId = id
            personObj?.personName = Contact.getNameForContact(id)
            personObj?.updateProfileImage()
            return personObj
        }
        return nil
    }
}
