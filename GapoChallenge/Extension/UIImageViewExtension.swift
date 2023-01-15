//
//  UIImageViewExtension.swift
//  GapoChallenge
//
//  Created by Chu Hung on 15/01/2023.
//

import Foundation
import UIKit

extension UIImageView {
    @IBInspectable var rounded: Bool {
        set {
            if newValue {
                clipsToBounds = true
                layer.cornerRadius = max(self.bounds.width, self.bounds.height) / 2
            }
        }
        get {
            return self.rounded
        }
    }
}
