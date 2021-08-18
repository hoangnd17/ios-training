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
    
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var isOwn: Employee?
    
    static func insertNewCertificate(id: Int16, name: String) -> Certificate? {
        let certificate = NSEntityDescription.insertNewObject(forEntityName: "Certificate", into: AppDelegate.managedObjectContext!) as! Certificate
        
        certificate.id = id
        certificate.name = name
        
        do {
            try AppDelegate.managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            print("Can't save Core. Error: \(nserror), \(nserror.userInfo)")
            return nil
        }
        print("Insert new certi: \(certificate.name ?? "")")
        return certificate
    }
    
    static func getAllCerti() -> [Certificate] {
        var result = [Certificate]()
        let moc = AppDelegate.managedObjectContext
        
        do {
            result = try moc?.fetch(Certificate.fetchRequest()) as! [Certificate]
        } catch {
            print("Cant fetch certi. Error: \(error)")
            return result
        }
        return result
    }
    
    static func deleteAllCerti() -> Void  {
        let moc = AppDelegate.managedObjectContext
        let allCerti = Certificate.getAllCerti()
        
        for certi in allCerti {
            moc?.delete(certi)
        }
        
        do {
            try AppDelegate.managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            print("Can't delete all certi. Error: \(nserror), \(nserror.userInfo)")
            return
        }
        print("Delete all certi!")
        return 
        
    }
    
    func toString() {
        print("Certi's detail. id: \(id), name: \(name ?? ""))")
    }
    
}

extension Certificate : Identifiable {
    
}
