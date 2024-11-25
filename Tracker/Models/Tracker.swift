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
}
