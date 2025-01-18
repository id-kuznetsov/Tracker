//
//  WeekDay.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 25.11.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    var fullName: String {
        switch self {
        case .monday: return L10n.WeekDayFull.monday
        case .tuesday: return L10n.WeekDayFull.tuesday
        case .wednesday: return L10n.WeekDayFull.wednesday
        case .thursday: return L10n.WeekDayFull.thursday
        case .friday: return L10n.WeekDayFull.friday
        case .saturday: return L10n.WeekDayFull.saturday
        case .sunday: return L10n.WeekDayFull.sunday
        }
    }
    
    var shortName: String {
        switch self {
        case .monday: return L10n.WeekDayShort.monday
        case .tuesday: return L10n.WeekDayShort.tuesday
        case .wednesday: return L10n.WeekDayShort.wednesday
        case .thursday: return L10n.WeekDayShort.thursday
        case .friday: return L10n.WeekDayShort.friday
        case .saturday: return L10n.WeekDayShort.saturday
        case .sunday: return L10n.WeekDayShort.sunday
        }
    }
}
