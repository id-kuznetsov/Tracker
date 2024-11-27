//
//  CategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 27.11.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func showSelectedCategory(category: String)
}
