//
//  TrackersFilter.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 24.01.2025.
//

import Foundation

enum TrackersFilter: CaseIterable {
    case allTrackers
    case forToday
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .allTrackers:
            return L10n.Trackers.Filters.allTrackers
        case .forToday:
            return L10n.Trackers.Filters.forToday
        case .completed:
            return L10n.Trackers.Filters.completed
        case .uncompleted:
            return L10n.Trackers.Filters.uncompleted
        }
    }
}
