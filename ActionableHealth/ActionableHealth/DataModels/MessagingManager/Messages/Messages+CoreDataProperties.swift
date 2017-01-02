//
//  Messages+CoreDataProperties.swift
//  
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData


extension Messages {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "Messages");
    }

    @NSManaged public var key: String?
    @NSManaged public var message: String?
    @NSManaged public var messageId: String?
    @NSManaged public var priority: String?
    @NSManaged public var type: String?
    @NSManaged public var timestamp: NSNumber?
    @NSManaged public var status: String?
    @NSManaged public var person: Person?
    @NSManaged public var lastMessagePerson: Person?

}
