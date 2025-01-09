//
//  AppStateManager.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 06.01.2025.
//

import Foundation

final class AppStateManager {

    static let shared = AppStateManager()
    
    var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: Keys.isFirstLaunch.rawValue)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: Keys.isFirstLaunch.rawValue)
        }
    }
    
    var lastSelectedCategory: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.lastSelectedCategory.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastSelectedCategory.rawValue)
        }
    }
    
    private enum Keys: String {
        case isFirstLaunch
        case lastSelectedCategory
    }
    
    private init() {}
}
