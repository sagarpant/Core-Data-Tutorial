//
//  CompanyListViewModel.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 16/08/22.
//

import Foundation
import CoreData

protocol CompanyListViewModel: TableViewModel {
    func data(indexPath: IndexPath) -> Company
    func updateSendSortedData(sendSortedData: Bool)
    func deleteCompany(indexPath: IndexPath)
}

final class CompanyListViewModelImp: CompanyListViewModel {
    private var companies: [Company] = []
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
        return companies.count
    }
    
    func start() {
       
        // Task 1 (Repeat)
        // Create a fetch request.
        // execute fetch request.
        // Assign it to the the employees array
        let fetchRequest = Company.fetchRequest()
        
        // Task 2 (Repeat)
        // Change the fetch request to take in to account the sort order
        if sendSortedData {
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        do {
            self.companies = try persistentContainer.viewContext.fetch(fetchRequest)
            delegate?.viewModelFetchedData(result: .success(()))
        } catch {
            delegate?.viewModelFetchedData(result: .failure(error))
        }
    }
    
    func data(indexPath: IndexPath) -> Company {
        return companies[indexPath.row]
    }
    
    func updateSendSortedData(sendSortedData: Bool) {
        self.sendSortedData = sendSortedData
    }
    
    func deleteCompany(indexPath: IndexPath) {
        let company = companies[indexPath.row]
        persistentContainer.viewContext.delete(company)
        try? persistentContainer.viewContext.save()
        start()
    }
}
