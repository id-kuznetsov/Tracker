//
//  StatisticType.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 21.01.2025.
//

import Foundation

enum StatisticType: CaseIterable {
    case bestPeriod
    case perfectDays
    case trackersCompleted
    case averageValue
    
    var title: String {
        switch self {
        case .bestPeriod:
            return L10n.Statistics.bestPeriod
        case .perfectDays:
            return L10n.Statistics.perfectDays
        case .trackersCompleted:
            return L10n.Statistics.trackersCompleted
        case .averageValue:
            return L10n.Statistics.averageValue
        }
    }
}
