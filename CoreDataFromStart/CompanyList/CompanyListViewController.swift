//
//  CompanyListViewController.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 16/08/22.
//

import UIKit

final class CompanyListViewController: UIViewController {
    
    private let viewModel: CompanyListViewModel
    static let companyListCellIdentifier = "EmployeeListCell"
    private var isSorted = false
    
    init(viewModel: CompanyListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.withAutoLayout()
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CompanyListViewController.companyListCellIdentifier)
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var fab: Button = {
        let fab = Button.withAutoLayout()
        return fab
    }()
    
    override func viewDidLoad() {
        viewModel.start()
        view.addSubview(tableView)
        view.addSubview(fab)
        view.setNeedsUpdateConstraints()
        render()
    }
    
    override func updateViewConstraints() {
        NSLayoutConstraint.activate(staticConstraints())
        super.updateViewConstraints()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            
            fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fab.heightAnchor.constraint(equalToConstant: 50),
            fab.widthAnchor.constraint(equalToConstant: 50),
            fab.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ]
    }
    
    private func render() {
        view.backgroundColor = .primaryColor
        fab.layer.cornerRadius = 25
        fab.backgroundColor = .buttonNormalColor
        navigationItem.title = "Company List"
        let image = UIImage(systemName: "plus")?.withTintColor(.white).withRenderingMode(.alwaysOriginal).resizeImage(targetSize: CGSize(width: 30, height: 30))
        fab.setImage(image, for: .normal)
        updateRighBarButton()
    }
}

extension CompanyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let employee = viewModel.data(indexPath: indexPath)
//        let viewModel = EmployeeDetailsViewModelImp(persistentContiner: viewModel.persistentContainer, employeeName: employee.firstName ?? "")
//        let vc = EmployeeDetailsViewController(viewModel: viewModel)
//        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CompanyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyListViewController.companyListCellIdentifier, for: indexPath)
        let company = viewModel.data(indexPath: indexPath)
        cell.textLabel?.text = company.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self]  _, indexPath in
            print(indexPath.row)
            self?.viewModel.deleteCompany(indexPath: indexPath)
        }
        return [deleteAction]
    }
    
}

extension CompanyListViewController: TableViewModelController {
    func viewModelFetchedData(result: Result<Void, Error>) {
        switch result {
        case .failure(let error):
            print(error)
        case .success():
            tableView.reloadData()
        }
    }
 
}

extension CompanyListViewController {

    func updateRighBarButton() {
        let btnFavourite = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        if isSorted {
            btnFavourite.setImage(UIImage(systemName: "arrow.up.arrow.down")?.withRenderingMode(.alwaysOriginal).withTintColor(.buttonNormalColor), for: .normal)
        } else {
            btnFavourite.setImage(UIImage(systemName: "arrow.up.arrow.down")?.withRenderingMode(.alwaysOriginal).withTintColor(.secondaryColor), for: .normal)
        }
        let rightButton = UIBarButtonItem(customView: btnFavourite)
        btnFavourite.addTarget(self, action: #selector(sortedBarButtnTap), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }


    @objc
    func sortedBarButtnTap() {
        isSorted = !self.isSorted;
        if isSorted {
            sorted();
        }else{
            unSorted();
        }
        self.updateRighBarButton();
    }


    func sorted() {
        viewModel.updateSendSortedData(sendSortedData: true)
    }

    func unSorted() {
        viewModel.updateSendSortedData(sendSortedData: false)
    }
}

