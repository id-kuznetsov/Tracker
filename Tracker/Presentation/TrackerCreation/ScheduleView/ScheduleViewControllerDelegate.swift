//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 26.11.2024.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func showSelectedDays(days: [WeekDay])
}
