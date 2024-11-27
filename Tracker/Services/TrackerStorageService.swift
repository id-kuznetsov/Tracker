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
    
    // MARK: - Public Properties
    
    var trackersMock = [TrackerCategory(title: "Учеба", trackers: [
        Tracker(
            id: UUID(),
            name: "Изучить collection view",
            color: .ypSection10,
            emoji: "🥇",
            schedule: [.monday, .tuesday, .wednesday, .thursday]
        ),
        Tracker(
            id: UUID(),
            name: "Моя очень длинная и детализированная категория",
            color: .ypSection1,
            emoji: "🤔",
            schedule: [.friday, .wednesday, .thursday]
        ),
        Tracker(
            id: UUID(),
            name: "Изучить search bar",
            color: .ypSection8,
            emoji: "🥇",
            schedule: [.monday, .tuesday, .wednesday, .saturday, .sunday]
        )
    ]
                                              )]
    
    // MARK: - Private Properties
    
    private(set) var trackers: [TrackerCategory] = []
    
    // MARK: - Initialisers
    
    private init() {}
    
    // MARK: - Private Methods
    
    func getCategoriesCount() -> Int {
        trackersMock.count
    }
    
    func addCategory(_ category: TrackerCategory) {
        trackers.append(category)
    }
    
    func addTracker(_ tracker: Tracker, to categoryTittle: String) {
        if let index = trackersMock.firstIndex(where: { $0.title == categoryTittle }) {
            let existingCategory = trackersMock[index]
            
            let updatedCategory = TrackerCategory(
                title: existingCategory.title,
                trackers: existingCategory.trackers + [tracker]
            )
            
            trackersMock[index] = updatedCategory
        }
    }
    
}
