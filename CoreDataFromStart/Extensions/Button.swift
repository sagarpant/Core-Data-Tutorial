//
//  Button.swift
//  GithubProfile
//
//  Created by Sagar Pant on 07/08/22.
//

import UIKit

final class Button: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if !isHighlighted {
                backgroundColor = .buttonNormalColor
            } else {
                backgroundColor = .buttonHighlightedColor
            }
        }
    }
}
