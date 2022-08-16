//
//  EmployeeDetailsViewController.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 15/08/22.
//

import Foundation
import UIKit

final class EmployeeDetailsViewController: UIViewController {
    
    private let viewModel: EmployeeDetailsViewModel
    
    init(viewModel: EmployeeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.withAutoLayout()
        
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView(arrangedSubviews: [employeeDetails, orgHierarchy, employeeTasksView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        return mainStackView
    }()
    
    private lazy var employeeDetails: EmployeeDetailsView = {
        let employeeDetails = EmployeeDetailsView.withAutoLayout()
        return employeeDetails
    }()
    
    private lazy var orgHierarchy: OrganisationHierarchy = {
        let orgHierarchy = OrganisationHierarchy.withAutoLayout()
        return orgHierarchy
    }()
    
    private lazy var employeeTasksView: EmployeeTasksView = {
        let employeeTasksView = EmployeeTasksView.withAutoLayout()
        return employeeTasksView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        view.backgroundColor = .primaryColor
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(mainStackView)
        view.setNeedsUpdateConstraints()
        render()
    }
    
    override func updateViewConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.updateViewConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ]
    }
    
    private func render() {
        navigationItem.title = "Employee Details"
        employeeDetails.viewData = viewModel.employeeDetailsViewData
        orgHierarchy.viewData = viewModel.orgHierarchyViewData
        employeeTasksView.viewData = viewModel.employeeTasksViewData
    }
}

extension EmployeeDetailsViewController: EmployeeDetailsDelegate {
    
    func employeeDetailsFetched(result: Result<Void, Error>) {
        switch result {
        case .failure(let error):
            print(error)
        case .success():
            render()
        }
    }
}

extension Employee {
    var employeeDetailsViewData: EmployeeDetailsView.ViewData {
        return EmployeeDetailsView.ViewData(age: Int(age),
                                            name: (firstName ?? "") + " " + (lastName ?? ""), companyName: employer?.name)
    }
    
    var orgHierarchyViewData: OrganisationHierarchy.ViewData {
        var reporteeArray: [String] = []
        reportees?.forEach {
            guard let reportee = $0 as? Employee else {
                return
            }
            reporteeArray.append(reportee.firstName ?? "")
        }
        
        return OrganisationHierarchy.ViewData(reportees: reporteeArray, manager: manager?.firstName)
    }
    
    var employeeTasksViewData: EmployeeTasksView.ViewData {
        var taskDescriptions: [String] = []
        tasks?.forEach {
            guard let task = $0 as? Task,
                  let taskDescription = task.taskDescription else {
                return
            }
            taskDescriptions.append(taskDescription)
        }
        return EmployeeTasksView.ViewData(employeeName: firstName ?? "",
                                          taskDescriptions: taskDescriptions)
    }
}

