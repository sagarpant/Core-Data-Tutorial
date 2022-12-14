//
//  AppDelegate.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 15/06/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreDataFromStart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        container.persistentStoreCoordinator.persistentStores.forEach { store in
            print(store.url)
        }
        let moc = container.viewContext
        
        let employeeFetchRequst = Employee.fetchRequest()
        if let countOfEmployees = try? moc.count(for: employeeFetchRequst),
           countOfEmployees > 0 {
            return container
        }

        let employee1 = Employee(context: moc)
        let employee2 = Employee(context: moc)
        let manager = Employee(context: moc)
        let company = Company(context: moc)
        moc.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        company.name = "X"
        company.location = "L1"
        
        for i in 1...100 {
            let employee = Employee(context: moc)
            employee.firstName = "employee\(i)"
            employee.age = 29
            employee.lastName = "employee\(i)last"
        }

        employee1.age = 30
        employee2.firstName = "Beta"
        employee2.lastName = "B"
        employee2.age = 40

        employee1.firstName = "Alpha"
        employee1.lastName = "A"

        employee1.employer = company
        employee2.employer = company
        manager.employer = company

        manager.firstName = "Gamma"
        manager.lastName = "G"
        manager.age = 45

        employee1.manager = manager
        employee2.manager = manager

        let task1 = Task(context: moc)
        let task2 = Task(context: moc)

        task1.taskDescription = "Attend bootcamp"
        task1.estimatedDays = 3
        task1.taskId = 1

        task2.taskDescription = "Implement Core Data"
        task2.estimatedDays = 4
        task2.taskId = 2

        task1.owner = employee2
        task2.owner = employee2
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

