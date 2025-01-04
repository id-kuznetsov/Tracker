//
//  TrackerStorageService.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 26.11.2024.
//

import CoreData

final class TrackerStorageService: NSObject {
    
    // MARK: - Constants
    
    static let shared = TrackerStorageService()
    static let didChangeNotification = Notification.Name(rawValue: "TrackerStorageServiceDidChange")
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
        return controller
    }()
    
    // MARK: - Initialisers
    
    private override init() {
        self.context = CoreDataManager.shared.viewContext
        super.init()
    }
    
    // MARK: - Public Methods
    
    func getCategoriesCount() -> Int {
        trackerCategoryStore.fetchCategories().count
    }
    
    func getCategories() -> [TrackerCategory] {
        trackerCategoryStore.fetchCategories()
    }
    
    func getCategory(at index: Int) -> String? {
        trackerCategoryStore.fetchCategories()[index].title
    }
    
    func createCategory(_ category: TrackerCategory) {
        do {
            let _ = try trackerCategoryStore.fetchOrCreateCategory(by: category.title)
        } catch {
            print("Error creating category: \(error) in file: \(#file), \(#line)")
        }
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        // TODO: delete category
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        do {
            try trackerStore.addTracker(tracker, to: categoryTitle)
            
            NotificationCenter.default.post(
                name: TrackerStorageService.didChangeNotification,
                object: nil
            )
        } catch {
            print("Error adding tracker: \(error) in file: \(#file), \(#line)")
        }
    }
    
    func deleteTracker(_ tracker: Tracker, from categoryTitle: String) {
        trackerStore.deleteTracker(tracker, from: categoryTitle)
    }
    
    func getTrackersForDate(_ date: Date, completedTrackers: Set<TrackerRecord>) -> [TrackerCategory] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let selectedWeekday = weekday == 1 ? 7 : weekday - 1
        guard let selectedWeekday = WeekDay(rawValue: selectedWeekday) else {
            return []
        }
        
        guard let sections = fetchedResultsController.sections else {
            return []
        }
        return sections.compactMap { section in
            let trackers = (section.objects as? [TrackerCoreData] ?? []).map { Tracker(from: $0) }
            let filteredTrackers = filterTrackers(
                trackers,
                for: date,
                completedTrackers: completedTrackers,
                weekday: selectedWeekday
            )
            return filteredTrackers.isEmpty ? nil : TrackerCategory(
                title: section.name,
                trackers: filteredTrackers
            )
        }
        
    }
    
    func addRecord(_ trackerRecord: TrackerRecord) {
        do {
            try trackerRecordStore.addRecord(trackerRecord)
        } catch {
            print("Error adding record: \(error) in file: \(#file), \(#line)")
        }
    }
    
    func removeRecord(_ trackerRecord: TrackerRecord) {
        do {
            try trackerRecordStore.removeRecord(trackerRecord)
        } catch {
            print("Error removing record: \(error) in file: \(#file), \(#line)")
        }
    }
    
    func getAllRecords() -> Set<TrackerRecord> {
        do {
            return try trackerRecordStore.getAllRecords()
        } catch {
            print("Error get records: \(error) in file: \(#file), \(#line)")
            return []
        }
    }
    
    // MARK: - Private Methods
    
    private func filterTrackers(
        _ trackers: [Tracker],
        for date: Date,
        completedTrackers: Set<TrackerRecord>,
        weekday: WeekDay
    ) -> [Tracker] {
        let calendar = Calendar.current
        return trackers.filter { tracker in
            guard tracker.schedule.contains(weekday) else { return false }
            if tracker.isHabit { return true }
            let isCompletedOnDate = completedTrackers.contains { record in
                record.id == tracker.id && calendar.isDate(record.date, inSameDayAs: date)
            }
            return isCompletedOnDate || completedTrackers.allSatisfy { $0.id != tracker.id }
        }
    }
}

// MARK: - Extensions

extension TrackerStorageService: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        NotificationCenter.default.post(
            name: TrackerStorageService.didChangeNotification,
            object: nil
        )
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    
}
