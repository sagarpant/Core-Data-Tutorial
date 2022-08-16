//
//  UIView+Extension.swift
//  GithubProfile
//
//  Created by Sagar Pant on 02/08/22.
//

import Foundation
import UIKit

// MARK: AutoLayout
extension UIView {
    
    /// Creates a view with auto layout enabled.
    public static func withAutoLayout() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

typealias HorizontalSpacers = (leading: UIView, trailing: UIView)
typealias VerticalSpacers = (top: UIView, bottom: UIView)
