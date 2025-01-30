//
//  AppStateManager.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 06.01.2025.
//

import Foundation

final class AppStateManager {
    
    static let shared = AppStateManager()
    
    private let storage = UserDefaults.standard
    
    var isFirstLaunch: Bool {
        get {
            return !storage.bool(forKey: Keys.isFirstLaunch.rawValue)
        }
        set {
            storage.set(!newValue, forKey: Keys.isFirstLaunch.rawValue)
        }
    }
    
    var lastSelectedCategory: String? {
        get {
            storage.string(forKey: Keys.lastSelectedCategory.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.lastSelectedCategory.rawValue)
        }
    }
    
    var selectedFilter: String? {
        get {
            storage.string(forKey: Keys.selectedFilter.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.selectedFilter.rawValue)
        }
    }
    
    private enum Keys: String {
        case isFirstLaunch
        case lastSelectedCategory
        case selectedFilter
    }
    
    private init() {}
}
