//
//  UIViewExtension.swift
//  GapoChallenge
//
//  Created by Chu Hung on 15/01/2023.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var conerRadius: CGFloat {
        set {
            self.clipsToBounds = true
            self.layer.cornerRadius = newValue
        }
        get {
            return self.conerRadius
        }
    }
}
