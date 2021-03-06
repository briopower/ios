//
//  Contact+CoreDataClass.swift
//
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData

//MARK:- Public Methods
open class Contact: NSManagedObject {

    class func saveContactObj(_ addressBook:AddressBook, forId: String, contextRef:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext) {
        if let context = contextRef{
            var contact:Contact?

            let contactsArr = CoreDataOperationsClass.fetchObjectsOfClassWithName("Contact", predicate: NSPredicate(format: "id = %@", forId), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: context) as? [Contact]

            if let temp = contactsArr?.first {
                contact = temp
                for obj in contactsArr ?? [] {
                    if obj != contact {
                        contextRef?.delete(obj)
                    }
                }
            }else{
                contact = Contact(entity: NSEntityDescription.entity(forEntityName: String(describing: Contact.self), in: context)!, insertInto: context)
                contact?.isAppUser = NSNumber(value: false as Bool)
                contact?.id = forId
            }

            if let temp = contact {
                let set = NSMutableSet(set: addressBook.contacts ?? NSSet())
                set.add(temp)
                addressBook.contacts = set
            }

        }
    }

    class func deleteContactsForRecordId(_ recordId:NSNumber, contextRef:NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext) {
        if let context = contextRef{
            let addBookArr = CoreDataOperationsClass.fetchObjectsOfClassWithName("AddressBook", predicate: NSPredicate(format: "recordId = %@", recordId), sortingKey: nil, isAcendingSort: true, fetchLimit: nil, context: context) as? [AddressBook]
            for obj in addBookArr ?? [] {
                if let arr = obj.contacts?.allObjects as? [Contact] {
                    for temp in arr {
                        context.delete(temp)
                    }
                }
            }
        }

    }
    class func getNameForContact(_ number:String) -> String? {
        if number == UserDefaults.getUserId() {
            return "You"
        }
        let contactsArr = CoreDataOperationsClass.fetchObjectsOfClassWithName("Contact", predicate: NSPredicate(format: "id = %@", number), sortingKey: nil, isAcendingSort: true, fetchLimit: nil) as? [Contact]

        if let temp = contactsArr?.first {
            for obj in contactsArr ?? [] {
                if obj != temp {
                    (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext.delete(obj)
                }
            }
            return temp.addressBook?.name
        }
        return nil
    }

    func getInviteMemberDict() -> [String:AnyObject] {
        var dict:[String:AnyObject] = [:]
        var arrOfMembers:[[String: String]] = []
        if let id = id{
            arrOfMembers.append(["emailOrPhone":id])
        }
        dict["members"] = arrOfMembers as AnyObject?
        return dict
    }

    
}
