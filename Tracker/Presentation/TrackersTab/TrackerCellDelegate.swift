//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 30.11.2024.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func didTapTrackerButton(_ cell: TrackersCollectionViewCell)
    func setPinnedTracker(_ tracker: Tracker, isPinned: Bool)
    func editTrackerAction(for tracker: Tracker)
    func deleteTrackerAction(for tracker: Tracker)
}
