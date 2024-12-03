//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 30.11.2024.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func didTapTrackerButton(_ cell: TrackersCollectionViewCell)
}
