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
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
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
    
    static func insertNewEmployee(id: Int16, name: String, fsu: String) -> Employee? {
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: AppDelegate.managedObjectContext!) as! Employee
        
        employee.id = id
        employee.name = name
        employee.fsu = fsu
        
        do {
            try AppDelegate.managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            print("Can't save Core. Error: \(nserror), \(nserror.userInfo)")
            return nil
        }
        print("Insert new employee: \(employee.name ?? "")")
        return employee
    }
    
    static func getAllEmployee() -> [Employee] {
        var result = [Employee]()
        let moc = AppDelegate.managedObjectContext
        
        do {
            result = try moc?.fetch(Employee.fetchRequest()) as! [Employee]
        } catch {
            print("Cant fetch employee. Error: \(error)")
            return result
        }
        return result
    }
    
    static func deleteAllEmployee() -> Void  {
        let moc = AppDelegate.managedObjectContext
        let allEmployee = Employee.getAllEmployee()
        
        for employee in allEmployee {
            moc?.delete(employee)
        }
        
        do {
            try AppDelegate.managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            print("Can't delete all employee. Error: \(nserror), \(nserror.userInfo)")
            return 
        }
        print("Delete all employee!")
        return
    }
    
    static func filterEmployeeByName(name: String?) -> [Employee] {
        var res = [Employee]()
        let moc = AppDelegate.managedObjectContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Employee.fetchRequest()
        

        if name != nil {
            fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", name!)
        }
        
        do {
            res = try moc?.fetch(fetchRequest) as! [Employee]
        } catch  {
            print("Cant fetch employee. Error: \(error)")
            return res
        }
        return res
    }
    
    func toString() {
        print("Employee's detail. id: \(id), name: \(name ?? ""), fsu:\(fsu ?? "")")
        if let certiList = self.has {
            if certiList.count == 0 {
                return
            }
            print("Employee's certi detail: ")
            for i in certiList {
                (i as! Certificate).toString()
            }
        }
    }
    
    func getAllCertiByEm() -> [Certificate] {
        var res = [Certificate]()
        if let certiList = self.has {
            if certiList.count == 0 {
                return []
            }
            print("Employee's certi detail: ")
            for i in certiList {
                res.append(i as! Certificate)
            }
        }
        return res
    }
    
}

extension Employee : Identifiable {
    
}
