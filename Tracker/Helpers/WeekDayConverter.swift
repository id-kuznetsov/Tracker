//
//  WeekDayConverter.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 20.12.2024.
//

import Foundation

final class WeekDayConverter {
    func convert(from weekDays: [WeekDay]) -> String {
        weekDays.map{ String($0.rawValue) }.joined(separator: ",")
    }

    func convert(from weekDay: String) -> [WeekDay] {
        return weekDay.components(separatedBy: ",").compactMap{ WeekDay(rawValue: Int($0) ?? 0) }
    }
}
