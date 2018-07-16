//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by Vidhan Nandi on 02/01/17.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Contact");
    }

    @NSManaged public var id: String?
    @NSManaged public var isAppUser: NSNumber?
    @NSManaged public var addressBook: AddressBook?

}
