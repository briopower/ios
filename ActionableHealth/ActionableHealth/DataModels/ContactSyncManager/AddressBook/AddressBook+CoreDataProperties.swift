//
//  AddressBook+CoreDataProperties.swift
//  
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData


extension AddressBook {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "AddressBook");
    }

    @NSManaged public var name: String?
    @NSManaged public var recordId: NSNumber?
    @NSManaged public var contacts: NSSet?

}

// MARK: Generated accessors for contacts
extension AddressBook {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(values: NSSet)

}
