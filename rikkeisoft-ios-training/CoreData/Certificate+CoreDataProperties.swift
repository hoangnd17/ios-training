//
//  Certificate+CoreDataProperties.swift
//  lesson13
//
//  Created by Đại Nguyễn  on 8/17/21.
//
//

import Foundation
import CoreData


extension Certificate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Certificate> {
        return NSFetchRequest<Certificate>(entityName: "Certificate")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int16
    @NSManaged public var em_id: Int16
    @NSManaged public var isOwn: Employee?

}

extension Certificate : Identifiable {

}
