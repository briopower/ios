//
//  AddressBook+CoreDataClass.swift
//
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData

//MARK:- Public Methods
open class AddressBook: NSManagedObject {

    class func saveAddressBookObj(_ contact:APContact, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) -> AddressBook? {
        if let context = contextRef{

            var addBook:AddressBook?
            let addBookArr = CoreDataOperationsClass.fetchObjectsOfClassWithName("AddressBook", predicate: NSPredicate(format: "recordId = %@", contact.recordID), sortingKey: ["name"], isAcendingSort: true, fetchLimit: nil, context: context) as? [AddressBook]

            if let temp = addBookArr?.first{
                addBook = temp
                for obj in addBookArr ?? [] {
                    if obj != addBook {
                        context.delete(obj)
                    }
                }
            }else{
                addBook = AddressBook(entity: NSEntityDescription.entity(forEntityName: String(describing: AddressBook), in: context)!, insertInto: context)
                addBook?.recordId = contact.recordID
            }

            addBook?.name = contact.name?.compositeName
            return addBook
        }
        return nil
    }
    
}
