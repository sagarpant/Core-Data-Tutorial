//
//  TaskListViewModel.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 16/08/22.
//

import Foundation
import CoreData

protocol TaskListViewModel: TableViewModel {
    func data(indexPath: IndexPath) -> Task
    func updateSendSortedData(sendSortedData: Bool)
    func deleteCompany(indexPath: IndexPath)
}

final class TaskListViewModelImp: TaskListViewModel {
    private var tasks: [Task] = []
    let persistentContainer: NSPersistentContainer
    weak var delegate: TableViewModelController?
    var sendSortedData: Bool = false {
        didSet {
            start()
        }
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    var numberOfRowsInSection: Int {
        return tasks.count
    }
    
    func start() {
       
        // Task 1 (Repeat)
        // Create a fetch request.
        // execute fetch request.
        // Assign it to the the employees array
        let fetchRequest = Task.fetchRequest()
        
        // Task 2 (Repeat)
        // Change the fetch request to take in to account the sort order
        if sendSortedData {
            let sortDescriptor = NSSortDescriptor(key: "taskDescription", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        do {
            self.tasks = try persistentContainer.viewContext.fetch(fetchRequest)
            delegate?.viewModelFetchedData(result: .success(()))
        } catch {
            delegate?.viewModelFetchedData(result: .failure(error))
        }
    }
    
    func data(indexPath: IndexPath) -> Task {
        return tasks[indexPath.row]
    }
    
    func updateSendSortedData(sendSortedData: Bool) {
        self.sendSortedData = sendSortedData
    }
    
    func deleteCompany(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        persistentContainer.viewContext.delete(task)
        try? persistentContainer.viewContext.save()
        start()
    }
}
