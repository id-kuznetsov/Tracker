//
//  MockTrackers.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 26.11.2024.
//

import UIKit

final class TrackerMock {
    let trackerCategory: TrackerCategory = TrackerCategory(title: "Учеба", trackers: [
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
    ])
}
