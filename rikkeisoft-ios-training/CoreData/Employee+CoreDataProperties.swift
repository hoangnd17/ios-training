//
//  Employee+CoreDataProperties.swift
//  lesson13
//
//  Created by Đại Nguyễn  on 8/17/21.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var fsu: String?
    @NSManaged public var name: Int16
    @NSManaged public var id: Int16
    @NSManaged public var has: NSSet?

}

// MARK: Generated accessors for has
extension Employee {

    @objc(addHasObject:)
    @NSManaged public func addToHas(_ value: Certificate)

    @objc(removeHasObject:)
    @NSManaged public func removeFromHas(_ value: Certificate)

    @objc(addHas:)
    @NSManaged public func addToHas(_ values: NSSet)

    @objc(removeHas:)
    @NSManaged public func removeFromHas(_ values: NSSet)

    static func insertNewEmployee(id: Int16, name: ) -> Employee? {
        
    }
 }

extension Employee : Identifiable {

}
