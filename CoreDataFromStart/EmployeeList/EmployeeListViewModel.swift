//
//  EmployeeListViewModel.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 15/08/22.
//

import Foundation
import CoreData

protocol ViewModel {
    func start()
    var persistentContainer: NSPersistentContainer { get }
}
protocol TableViewModel: ViewModel {
    var numberOfRowsInSection: Int { get }
}

protocol EmployeeListViewModel: TableViewModel {
    func data(indexPath: IndexPath) -> Employee
    func updateSendSortedData(sendSortedData: Bool)
    func deleteEmployee(indexPath: IndexPath)
}

protocol TableViewModelController: AnyObject {
    func viewModelFetchedData(result: Result<Void, Error>)
}

final class EmployeeListViewModelImp: EmployeeListViewModel {

    private var employees: [Employee] = []
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
        return employees.count
    }
    
    func start() {
       
        // Task 1
        // Create a fetch request.
        // execute fetch request.
        // Assign it to the the employees array
        let fetchRequest = Employee.fetchRequest()
        
        // Task 2
        // Change the fetch request to take in to account the sort order
        if sendSortedData {
            let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        do {
            self.employees = try persistentContainer.viewContext.fetch(fetchRequest)
            delegate?.viewModelFetchedData(result: .success(()))
        } catch {
            delegate?.viewModelFetchedData(result: .failure(error))
        }
    }
    
    func data(indexPath: IndexPath) -> Employee {
        return employees[indexPath.row]
    }
    
    func updateSendSortedData(sendSortedData: Bool) {
        self.sendSortedData = sendSortedData
    }
    
    func deleteEmployee(indexPath: IndexPath) {
        let employee = employees[indexPath.row]
        persistentContainer.viewContext.delete(employee)
        try? persistentContainer.viewContext.save()
        start()
    }
}
