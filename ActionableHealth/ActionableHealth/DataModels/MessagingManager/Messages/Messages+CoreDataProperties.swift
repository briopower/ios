//
//  Messages+CoreDataProperties.swift
//  
//
//  Created by Vidhan Nandi on 14/02/17.
//
//

import Foundation
import CoreData


extension Messages {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Messages");
    }

    @NSManaged public var key: String?
    @NSManaged public var message: String?
    @NSManaged public var messageId: String?
    @NSManaged public var priority: String?
    @NSManaged public var status: String?
    @NSManaged public var timestamp: NSNumber?
    @NSManaged public var type: String?
    @NSManaged public var msgDate: Date?
    @NSManaged public var lastMessagePerson: Person?
    @NSManaged public var person: Person?

}
