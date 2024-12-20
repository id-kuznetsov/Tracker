//
//  TrackerStore.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 18.12.2024.
//

import CoreData

final class TrackerStore {
    
    enum TrackerStoreError: Error {
        case failedToAddTracker
    }
    
    private let coreDataManager =  CoreDataManager.shared
    private let context: NSManagedObjectContext
    private let colorMarshaller = UIColorMarshalling()
    private let weekDayConverter = WeekDayConverter()

    convenience init() {
        let context = CoreDataManager.shared.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
//    func fetchTrackers() -> [Tracker] {
//        let fetchRequest: NSFetchRequest<TrackerCoreData>
//        
//    }
    
    func addTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = colorMarshaller.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = weekDayConverter.convert(from: tracker.schedule)
        trackerCoreData.isHabit = tracker.isHabit

        do {
            try context.save()
        } catch {
            throw TrackerStoreError.failedToAddTracker
        }
    }
}
