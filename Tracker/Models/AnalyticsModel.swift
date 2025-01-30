//
//  AnalyticsModel.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 28.01.2025.
//

import Foundation

enum AnalyticsModel {
    enum Event: String {
        case open
        case click
        case close
    }
    
    enum Screen: String {
        case main
    }
    
    enum Item: String {
        case addTrack
        case track
        case filter
        case edit
        case delete
    }
}
