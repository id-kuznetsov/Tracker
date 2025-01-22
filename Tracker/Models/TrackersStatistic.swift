//
//  TrackersStatistic.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 21.01.2025.
//

import Foundation

struct TrackersStatistics {
    let bestPeriod: Int
    let perfectDays: Int
    let trackersCompleted: Int
    let averageValue: Int
    
    func value(for type: StatisticType) -> Int {
        switch type {
        case .bestPeriod:
            return bestPeriod
        case .perfectDays:
            return perfectDays
        case .trackersCompleted:
            return trackersCompleted
        case .averageValue:
            return averageValue
        }
    }
}
