//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 18.12.2024.
//

import CoreData

final class TrackerRecordStore {
    enum TrackerRecordStoreError: Error {
        case failedToFetchRecords
        case failedToAddRecord
        case failedToRemoveRecord
    }
    
    private let context: NSManagedObjectContext

    convenience init() {
        let context = CoreDataManager.shared.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAllRecords() throws -> Set<TrackerRecord> {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            
            let records = results.compactMap { TrackerRecord(id: $0.id ?? UUID(), date: $0.date ?? Date()) }
            
            return Set(records)
        } catch {
            throw TrackerRecordStoreError.failedToFetchRecords
        }
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        let trackerRecord = TrackerRecordCoreData(context: context)
        trackerRecord.id = record.id
        trackerRecord.date = record.date
        
        do {
            try context.save()
        } catch {
            throw TrackerRecordStoreError.failedToAddRecord
        }
    }
    
    func removeRecord(_ record: TrackerRecord) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: record.date)
        
        
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", record.id as CVarArg, startOfDay as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let trackerRecordCoreData = results.first {
                context.delete(trackerRecordCoreData)
                try context.save()
            }
        } catch {
            throw TrackerRecordStoreError.failedToRemoveRecord
        }
    }
}
