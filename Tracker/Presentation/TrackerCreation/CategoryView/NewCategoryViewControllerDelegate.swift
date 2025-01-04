//
//  NewCategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 31.12.2024.
//

import Foundation

protocol NewCategoryViewControllerDelegate: AnyObject {
    func didTapDoneButton(categoryTitle: String)
}