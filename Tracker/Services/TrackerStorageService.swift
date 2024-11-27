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
    
    // MARK: - Private Properties
    
    private(set) var trackers: [Tracker] = []
    
    // MARK: - Initialisers
    
    private init() {}
}
