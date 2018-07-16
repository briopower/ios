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

    @nonobjc public override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "AddressBook");
    }

    @NSManaged public var name: String?
    @NSManaged public var recordId: NSNumber?
    @NSManaged public var contacts: NSSet?

}

// MARK: Generated accessors for contacts
extension AddressBook {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}
