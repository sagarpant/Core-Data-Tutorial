//
//  Task+CoreDataProperties.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 16/08/22.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var estimatedDays: Int32
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskId: Int32
    @NSManaged public var owner: Employee?

}

extension Task : Identifiable {

}
