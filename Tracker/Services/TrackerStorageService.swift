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
    static let didChangeRecord = Notification.Name(rawValue: "TrackerStorageServiceDidChangeRecord")
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let statisticStore = StatisticStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = []
        
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

    
    func getCategories() -> [TrackerCategory] {
        trackerCategoryStore.fetchCategories()
    }
    
    func getCategory(at index: Int) -> String? {
        trackerCategoryStore.fetchCategories()[index].title
    }
    
    func getCategory(for tracker: Tracker) -> String? {
        do {
            return try trackerCategoryStore.fetchCategory(for: tracker.id)
        } catch {
            print("Error getting category: \(error) in file: \(#file), \(#line)")
        }
        return nil
    }
    
    func createCategory(_ category: TrackerCategory) {
        do {
            let _ = try trackerCategoryStore.fetchOrCreateCategory(by: category.title)
        } catch {
            print("Error creating category: \(error) in file: \(#file), \(#line)")
        }
    }
    
    func editCategory(_ category: String, with newTitle: String) {
        do {
            try trackerCategoryStore.updateCategory(oldTitle: category, newTitle: newTitle)
        } catch {
            print("Error editing category: \(error) in file: \(#file), \(#line)")
        }
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        do {
            try trackerCategoryStore.deleteCategory(category)
        } catch {
            print("Error deleting category: \(error) in file: \(#file), \(#line)")
        }
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
    
    func updateTracker(_ updatedTracker: Tracker, to categoryTitle: String) {
        do {
            try trackerStore.updateTracker(updatedTracker, to: categoryTitle)
            
            NotificationCenter.default.post(
                name: TrackerStorageService.didChangeNotification,
                object: nil
            )
        } catch {
            print("Error editing tracker: \(error) in file: \(#file), \(#line)")
        }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        trackerStore.deleteTracker(tracker)
        removeAllRecords(tracker.id)
    }
    
    func setPinnedTracker(_ tracker: Tracker, isPinned: Bool) {
        trackerStore.setPinnedTracker(tracker, isPinned: isPinned)
        NotificationCenter.default.post(
            name: TrackerStorageService.didChangeNotification,
            object: nil
        )
    }
    
    func getTrackersForDate(_ date: Date, completedTrackers: Set<TrackerRecord>) -> [TrackerCategory] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let selectedWeekday = weekday == 1 ? 7 : weekday - 1
        guard let rawSelectedWeekday = WeekDay(rawValue: selectedWeekday) else {
            return []
        }
        
        let trackersWithCategory = trackerStore.fetchTrackersWithCategory(for: selectedWeekday)
        
        var pinnedTrackers: [Tracker] = []
        
        var categories: [TrackerCategory] = trackersWithCategory.compactMap { category in
            
            let filteredTrackers = filterTrackers(
                category.trackers,
                for: date,
                completedTrackers: completedTrackers,
                weekday: rawSelectedWeekday
            )
            pinnedTrackers.append(contentsOf: filteredTrackers.filter { $0.isPinned })

            let nonPinnedTrackers = filteredTrackers.filter { !$0.isPinned }
            
            return nonPinnedTrackers.isEmpty ? nil : TrackerCategory(
                title: category.title,
                trackers: nonPinnedTrackers
            )
        }
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(title: "Закрепленные", trackers: pinnedTrackers)
            categories.insert(pinnedCategory, at: 0)
        }
        return categories
    }
    
    func addRecord(_ trackerRecord: TrackerRecord) {
        do {
            try trackerRecordStore.addRecord(trackerRecord)
            NotificationCenter.default.post(
                name: TrackerStorageService.didChangeRecord,
                object: nil
            )
        } catch {
            print("Error adding record: \(error) in file: \(#file), \(#line)")
        }
    }
    
    func removeRecord(_ trackerRecord: TrackerRecord) {
        do {
            try trackerRecordStore.removeRecord(trackerRecord)
            NotificationCenter.default.post(
                name: TrackerStorageService.didChangeRecord,
                object: nil
            )
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
    
    func calculateStatistic() -> TrackersStatistics {
        let bestPeriod = calculateBestPeriod()
        let perfectDays = calculatePerfectDays()
        let trackersCompleted = getAllRecords().count
        let averageValue = calculateAverageValue()
        
        let statistic = TrackersStatistics(
            bestPeriod: bestPeriod,
            perfectDays: perfectDays,
            trackersCompleted: trackersCompleted,
            averageValue: averageValue
        )
        
        do {
            try statisticStore.saveStatistic(statistic)
        } catch {
            print("Error saving statistic: \(error) in file: \(#file), \(#line)")
        }
        
        return statistic
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
    
    private func removeAllRecords(_ trackerRecordID: UUID) {
        do {
            try trackerRecordStore.removeAllRecords(for: trackerRecordID)
            NotificationCenter.default.post(
                name: TrackerStorageService.didChangeNotification,
                object: nil
            )
        } catch {
            print("Error removing record: \(error) in file: \(#file), \(#line)")
        }
    }
    
    private func calculateBestPeriod() -> Int {
        let records = getAllRecords().sorted(by: { $0.date < $1.date })
        guard !records.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        var maxStreak = 0
        var currentStreak = 1
        
        for i in 1..<records.count {
            let previousDate = records[i - 1].date
            let currentDate = records[i].date
            
            if calendar.isDate(currentDate, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: previousDate)!) {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return max(maxStreak, currentStreak)
    }
    
    private func calculatePerfectDays() -> Int {
        let records = getAllRecords()
        guard !records.isEmpty else { return 0 }
        let allTrackers = trackerStore.fetchTrackers()
        guard !allTrackers.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let groupedByDate = Dictionary(grouping: records, by: { calendar.startOfDay(for: $0.date) })
        
        var perfectDaysCount = 0
        
        for (date, dailyRecords) in groupedByDate {
            let completedTrackerIDs = Set(dailyRecords.map { $0.id })
            
            let weekday = calendar.component(.weekday, from: date)
            guard let selectedWeekday = WeekDay(rawValue: weekday == 1 ? 7 : weekday - 1) else {
                continue
            }
 
            let plannedTrackers = allTrackers.filter { $0.schedule.contains(selectedWeekday) && $0.isHabit }
            let plannedTrackerIDs = Set(plannedTrackers.map { $0.id })
            
            if plannedTrackerIDs.isSubset(of: completedTrackerIDs) {
                perfectDaysCount += 1
            }
        }
        return perfectDaysCount
    }
    
    private func calculateAverageValue() -> Int {
        let records = getAllRecords()
        guard !records.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let groupedByDate = Dictionary(grouping: records, by: { calendar.startOfDay(for: $0.date) })
        let totalDays = groupedByDate.count
        let totalRecords = records.count
        
        return totalDays > 0 ? totalRecords / totalDays : 0
    }
}

// MARK: - Extensions

extension TrackerStorageService: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        NotificationCenter.default.post(
            name: TrackerStorageService.didChangeNotification,
            object: nil
        )
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}
}
