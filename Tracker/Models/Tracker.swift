//
//  Tracker.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 24.11.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let isHabit: Bool
    
    init(id: UUID,
         name: String,
         color: UIColor,
         emoji: String,
         schedule: [WeekDay],
         isHabit: Bool) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.isHabit = isHabit
    }
    
    init(from coreData: TrackerCoreData) {
        self.id = coreData.id ?? UUID()
        self.name = coreData.name ?? ""
        self.color = UIColorMarshalling().color(from: coreData.color ?? "")
        self.emoji = coreData.emoji ?? ""
        self.schedule = WeekDayConverter().convert(from: coreData.schedule ?? "")
        self.isHabit = coreData.isHabit
    }
}
