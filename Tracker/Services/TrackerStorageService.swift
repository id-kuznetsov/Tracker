//
//  TrackerStorageService.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 26.11.2024.
//

import Foundation

final class TrackerStorageService {
    
    // MARK: - Constants
    
    static let shared = TrackerStorageService()
    static let didChangeNotification = Notification.Name(rawValue: "TrackerStorageServiceDidChange")

    // MARK: - Private Properties
    
    private(set) var trackers: [TrackerCategory] = [
        TrackerCategory(title: "Учеба", trackers: [
            Tracker(
                id: UUID(),
                name: "Изучить collection view",
                color: .ypSection10,
                emoji: "🥇",
                schedule: [.monday, .wednesday]
            ),
            Tracker(
                id: UUID(),
                name: "Эта строка для теста: 38 символов!",
                color: .ypSection1,
                emoji: "🤔",
                schedule: [.tuesday, .thursday]
            ),
            Tracker(
                id: UUID(),
                name: "Изучить search bar",
                color: .ypSection8,
                emoji: "🥇",
                schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
            )
        ]),
        TrackerCategory(title: "Спорт", trackers: [
            Tracker(
                id: UUID(),
                name: "Утренний бег",
                color: .ypSection5,
                emoji: "🏃",
                schedule: [.monday, .wednesday]
            ),
            Tracker(
                id: UUID(),
                name: "Йога",
                color: .ypSection7,
                emoji: "🧘",
                schedule: [.tuesday, .thursday, .saturday]
            ),
            Tracker(
                id: UUID(),
                name: "Футбол",
                color: .ypSection8,
                emoji: "⚽️",
                schedule: [.sunday]
            )
        ])
    ]
    
    // MARK: - Initialisers
    
    private init() {}
    
    // MARK: - Private Methods
    
    func getCategoriesCount() -> Int {
        trackers.count
    }
    
    func addCategory(_ category: TrackerCategory) {
        trackers.append(category)
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        // TODO: delete category
    }
    
    func addTracker(_ tracker: Tracker, to categoryTittle: String) {
        if let index = trackers.firstIndex(where: { $0.title == categoryTittle }) {
            let oldCategory = trackers[index]
            
            let newCategory = TrackerCategory(
                title: oldCategory.title,
                trackers: oldCategory.trackers + [tracker]
            )
            
            trackers[index] = newCategory
            
            NotificationCenter.default.post(
                name: TrackerStorageService.didChangeNotification,
                object: nil
            )
        }
    }
    
    func deleteTracker(_ tracker: Tracker, from categoryTittle: String) {
        // TODO: delete tracker
    }
    
    func getTrackersForDate(_ date: Date) -> [TrackerCategory] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let selectedWeekday = weekday == 1 ? 7 : weekday - 1
        
        guard let selectedWeekday = WeekDay(rawValue: selectedWeekday) else {
            return []
        }
        
        let filteredCategories = trackers.map { category in 
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.schedule.contains(selectedWeekday)
            }
            
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        return filteredCategories.filter { !$0.trackers.isEmpty }
    }
    
    
}
