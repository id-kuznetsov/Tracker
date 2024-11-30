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
    
    // MARK: - Public Properties
    //    MARK: для теста плейсхолдера ⬇️⬇️⬇️
//    var trackersMock = [TrackerCategory(title: "Спорт", trackers: [])]
    var trackersMock = [
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
            )
        ])
    ]
    
    // MARK: - Private Properties
    
    private(set) var trackers: [TrackerCategory] = []
    
    // MARK: - Initialisers
    
    private init() {}
    
    // MARK: - Private Methods
    
    func getCategoriesCount() -> Int {
        trackersMock.count
    }
    
    func addCategory(_ category: TrackerCategory) {
        trackersMock.append(category)
//        trackers.append(category)
    }
    
    func addTracker(_ tracker: Tracker, to categoryTittle: String) {
        if let index = trackersMock.firstIndex(where: { $0.title == categoryTittle }) {
            let oldCategory = trackersMock[index]
            
            let newCategory = TrackerCategory(
                title: oldCategory.title,
                trackers: oldCategory.trackers + [tracker]
            )
            
            trackersMock[index] = newCategory
            
            NotificationCenter.default.post(
                name: TrackerStorageService.didChangeNotification,
                object: nil
            )
        }
    }
    
    func getTrackersForDate(_ date: Date) -> [TrackerCategory] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let selectedWeekday = weekday == 1 ? 7 : weekday - 1
        
        guard let selectedWeekday = WeekDay(rawValue: selectedWeekday) else {
            return []
        }
        
        let filteredCategories = trackersMock.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.schedule.contains(selectedWeekday)
            }
            
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        return filteredCategories.filter { !$0.trackers.isEmpty }
    }
    
}
