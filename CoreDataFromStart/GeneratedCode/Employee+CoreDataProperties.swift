//
//  Employee+CoreDataProperties.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 16/08/22.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var age: Int32
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var employer: Company?
    @NSManaged public var manager: Employee?
    @NSManaged public var reportees: NSSet?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for reportees
extension Employee {

    @objc(addReporteesObject:)
    @NSManaged public func addToReportees(_ value: Employee)

    @objc(removeReporteesObject:)
    @NSManaged public func removeFromReportees(_ value: Employee)

    @objc(addReportees:)
    @NSManaged public func addToReportees(_ values: NSSet)

    @objc(removeReportees:)
    @NSManaged public func removeFromReportees(_ values: NSSet)

}

// MARK: Generated accessors for tasks
extension Employee {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Employee : Identifiable {

}
