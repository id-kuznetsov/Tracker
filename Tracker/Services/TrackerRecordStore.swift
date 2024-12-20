//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 18.12.2024.
//

import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext

    convenience init() {
        let context = CoreDataManager.shared.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
}
