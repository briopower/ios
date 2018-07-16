//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Vidhan Nandi on 03/02/17.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Person");
    }

    @NSManaged public var personId: String?
    @NSManaged public var personImage: String?
    @NSManaged public var personName: String?
    @NSManaged public var lastTrack: String?
    @NSManaged public var lastMessage: Messages?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension Person {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Messages)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Messages)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
