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
    private let trackerCategoryStore = TrackerCategoryStore()
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
    
    func fetchTrackers() -> [Tracker] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        do {
            let trackerCoreDataArray = try context.fetch(fetchRequest)
            return trackerCoreDataArray.map { trackerCoreData in
                Tracker(from: trackerCoreData)
            }
        } catch {
            print("Error fetching trackers: \(error)")
            return []
        }
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        let trackerCategoryCoreData = try trackerCategoryStore.fetchOrCreateCategory(by: categoryTitle)
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = colorMarshaller.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = weekDayConverter.convert(from: tracker.schedule)
        trackerCoreData.isHabit = tracker.isHabit
        trackerCoreData.category = trackerCategoryCoreData
        
        do {
            try context.save()
        } catch {
            throw TrackerStoreError.failedToAddTracker
        }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let trackerCoreData = results.first {
                context.delete(trackerCoreData)
                try context.save()
            }
        } catch {
            print("Error deleting tracker: \(error)")
        }
    }
}
