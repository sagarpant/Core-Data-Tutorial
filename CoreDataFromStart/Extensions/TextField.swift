//
//  TextField.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import UIKit

final class TextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
}
