//
//  FilterViewControllerDelegate.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 24.01.2025.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func updateFilter(_ filter: TrackersFilter)
}
