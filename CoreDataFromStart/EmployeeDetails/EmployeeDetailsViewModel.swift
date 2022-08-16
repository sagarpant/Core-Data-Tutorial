//
//  EmployeeDetailsViewModel.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 15/08/22.
//

import Foundation
import CoreData

protocol EmployeeDetailsDelegate: AnyObject {
    func employeeDetailsFetched(result: Result<Void, Error>)
}

enum EmployeeDetailsFetchError: Error {
    case employeeNotFound
}

protocol EmployeeDetailsViewModel: ViewModel {
    var employeeDetailsViewData: EmployeeDetailsView.ViewData? { get }
    var orgHierarchyViewData: OrganisationHierarchy.ViewData? { get }
    var employeeTasksViewData: EmployeeTasksView.ViewData? { get }
}

final class EmployeeDetailsViewModelImp: EmployeeDetailsViewModel {

    let persistentContainer: NSPersistentContainer
    private let employeeName: String
    private var employee: Employee?
    weak var delegate: EmployeeDetailsDelegate?
    
    init(persistentContiner: NSPersistentContainer,
         employeeName: String) {
        self.persistentContainer = persistentContiner
        self.employeeName = employeeName
    }
    
    func start() {
        // Task 3: Get an employee by name
        // Predicate based query
        let fetchRequest = Employee.fetchRequest()
        let predicate = NSPredicate(format: "firstName == %@", argumentArray: [employeeName])
        fetchRequest.predicate = predicate
        let employee = try? persistentContainer.viewContext.fetch(fetchRequest).first
        guard let employee = employee else {
            delegate?.employeeDetailsFetched(result: .failure(EmployeeDetailsFetchError.employeeNotFound))
            return
        }
        self.employee = employee
        delegate?.employeeDetailsFetched(result: .success(()))
    }
    
    var employeeDetailsViewData: EmployeeDetailsView.ViewData? {
        return employee?.employeeDetailsViewData
    }
    
    var orgHierarchyViewData: OrganisationHierarchy.ViewData? {
        return employee?.orgHierarchyViewData
    }
    
    var employeeTasksViewData: EmployeeTasksView.ViewData? {
        return employee?.employeeTasksViewData
    }
}
