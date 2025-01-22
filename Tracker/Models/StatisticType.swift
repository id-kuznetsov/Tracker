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
            return "Лучший период" // TODO: локаль!
        case .perfectDays:
            return "Идеальные дни"
        case .trackersCompleted:
            return "Трекеров завершено"
        case .averageValue:
            return "Среднее значение"
        }
    }
}
