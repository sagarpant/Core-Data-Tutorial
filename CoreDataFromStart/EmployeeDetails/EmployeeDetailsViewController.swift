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
        let mainStackView = UIStackView(arrangedSubviews: [employeeDetails, orgHierarchy])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        view.backgroundColor = .primaryColor
        view.addSubview(scrollView)
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
    }
}

final class EmployeeDetailsView: UIView {
    
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, company])
        mainStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.spacing = 20
        mainStackView.axis = .vertical
        return mainStackView
    }()
    
    private lazy var nameLabel = UILabel.withAutoLayout()
    private lazy var ageLabel = UILabel.withAutoLayout()
    private lazy var company = UILabel.withAutoLayout()
    
    required init?(coder: NSCoder) {
        fatalError("initWithCoder: not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(mainStackView)
        setNeedsUpdateConstraints()
    }
    
    override func setNeedsUpdateConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.setNeedsUpdateConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor)
        ]
    }
    
    struct ViewData {
        let age: Int
        let name: String?
        let companyName: String?
    }
    
    var viewData: ViewData? {
        didSet {
            render()
        }
    }
    
    private func render() {
        nameLabel.text = "Name: " + (viewData?.name ?? "")
        ageLabel.text = "Age: " + String(viewData?.age ?? 0)
        company.text = "Company: " + (viewData?.companyName ?? "")
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

final class OrganisationHierarchy: UIView {
    
    private lazy var managerLabel = UILabel.withAutoLayout()
    private lazy var reporteesLabel: UILabel = {
        let reporteesLabel = UILabel.withAutoLayout()
        reporteesLabel.text = "Reportees"
        return reporteesLabel
    }()
    
    static let organisationHierarchyCell = "OrganisationHierarchy"
    private lazy var mainStackView: UIStackView = {
       let mainStackView = UIStackView(arrangedSubviews: [managerLabel, reporteesLabel, reporteesList])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        return mainStackView
    }()
    
    private lazy var reporteesList: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: OrganisationHierarchy.organisationHierarchyCell)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(mainStackView)
        setNeedsUpdateConstraints()
        render()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.updateConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            reporteesList.heightAnchor.constraint(equalToConstant: 100)
        ]
    }
    
    struct ViewData {
        let reportees: [String]
        let manager: String?
    }
    
    var viewData: ViewData? {
        didSet {
            render()
        }
    }
    
    private func render() {
        reporteesList.reloadData()
        managerLabel.text = "Manager Name: " + (viewData?.manager ?? "No manager")
    }
    
}

extension OrganisationHierarchy: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OrganisationHierarchy: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewData?.reportees.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrganisationHierarchy.organisationHierarchyCell, for: indexPath)
        cell.textLabel?.text = viewData?.reportees[indexPath.row]
        return cell
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
}

