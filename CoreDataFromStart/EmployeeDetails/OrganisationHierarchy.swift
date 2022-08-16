//
//  OrganisationHierarchy.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 17/08/22.
//

import UIKit

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
