//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 28.01.2025.
//

import UIKit

extension UIColor {
    func isEqualToColor(_ otherColor: UIColor) -> Bool {
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0

        self.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        otherColor.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        return red1 == red2 && green1 == green2 && blue1 == blue2 && alpha1 == alpha2
    }
}
