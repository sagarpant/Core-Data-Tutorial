//
//  EmployeeDetailsView.swift
//  CoreDataFromStart
//
//  Created by Sagar Pant on 17/08/22.
//

import UIKit

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
        company.text = "Company: " + (viewData?.companyName ?? "No Employer")
    }
}

