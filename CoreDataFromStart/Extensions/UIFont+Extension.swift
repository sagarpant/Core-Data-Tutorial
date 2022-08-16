//
//  UIFont.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import Foundation
import UIKit

extension UIFont {
    static let headline = UIFont.preferredFont(forTextStyle: .headline)
    
    
    static let titleFont = UIFont(descriptor: .titleFontDescriptor, size: UIFontDescriptor.titleFontDescriptor.pointSize)
    static let dateFonts = UIFont(descriptor: .dateFontsDescriptor, size: UIFontDescriptor.dateFontsDescriptor.pointSize)
    static let dateValueFont = UIFont(descriptor: .dateValueFontDescriptor, size: UIFontDescriptor.dateValueFontDescriptor.pointSize)
}

extension UIFontDescriptor {
    static let titleFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline)
    static let dateFontsDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).withSymbolicTraits(.traitBold)!
    static let dateValueFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline)
}
