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
public class AddressBook: NSManagedObject {

    class func saveAddressBookObj(contact:APContact, contextRef:NSManagedObjectContext? = AppDelegate.getAppDelegateObject()?.managedObjectContext) -> AddressBook? {
        if let context = contextRef{

            var addBook:AddressBook?
            let addBookArr = CoreDataOperationsClass.fetchObjectsOfClassWithName(String(AddressBook), predicate: NSPredicate(format: "recordId = %@", contact.recordID), sortingKey: ["name"], isAcendingSort: true, fetchLimit: nil, context: context) as? [AddressBook]

            if let temp = addBookArr?.first{
                addBook = temp
                for obj in addBookArr ?? [] {
                    if obj != addBook {
                        context.deleteObject(obj)
                    }
                }
            }else{
                addBook = AddressBook(entity: NSEntityDescription.entityForName(String(AddressBook), inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
                addBook?.recordId = contact.recordID
            }

            addBook?.name = contact.name?.compositeName
            return addBook
        }
        return nil
    }
    
}
