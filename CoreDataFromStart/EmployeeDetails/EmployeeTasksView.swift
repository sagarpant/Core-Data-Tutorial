//
//  EmployeeTasksView.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 17/08/22.
//

import UIKit

final class EmployeeTasksView: UIView {
    
    static let employeeTasksViewCell = "employeeTasksViewCell"
    private lazy var employeeTasksLabel = UILabel.withAutoLayout()
    private lazy var employeeTaskList: UITableView = {
        let tableView = UITableView()
         tableView.delegate = self
         tableView.dataSource = self
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: EmployeeTasksView.employeeTasksViewCell)
         return tableView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView(arrangedSubviews: [employeeTasksLabel, employeeTaskList])
        mainStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.spacing = 20
        mainStackView.axis = .vertical
        return mainStackView
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
    
    override func setNeedsUpdateConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.setNeedsUpdateConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            employeeTaskList.heightAnchor.constraint(equalToConstant: 100)
        ]
    }
    
    struct ViewData {
        let employeeName: String
        let taskDescriptions: [String]
    }
    
    var viewData: ViewData? {
        didSet {
            render()
        }
    }
    
    private func render() {
        employeeTasksLabel.text = "\(viewData?.employeeName ?? "")'s Tasks"
        employeeTaskList.reloadData()
    }
}

extension EmployeeTasksView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EmployeeTasksView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewData?.taskDescriptions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTasksView.employeeTasksViewCell, for: indexPath)
        cell.textLabel?.text = viewData?.taskDescriptions[indexPath.row]
        return cell
    }
}
