//
//  ScheduleViewCellDelegate.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 26.11.2024.
//

import Foundation

protocol ScheduleViewCellDelegate: AnyObject {
    func daySelected(cell: ScheduleViewCell)
    func dayDeselected(cell: ScheduleViewCell)
}
