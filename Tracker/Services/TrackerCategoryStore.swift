//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 18.12.2024.
//

import CoreData

final class TrackerCategoryStore {
    
    enum TrackerCategoryStoreError: Error {
        case failedToFetchCategory
        case failedToCreateCategory
    }
    
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = CoreDataManager.shared.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchCategories() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            let categoryCoreDataArray = try context.fetch(fetchRequest)
            return categoryCoreDataArray.map {
                TrackerCategory(
                    title: $0.title ?? "",
                    trackers: []
                )
            }
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }
    
    func fetchCategory(by title: String) throws -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let categories = try context.fetch(fetchRequest)
            return categories.first
        } catch {
            throw TrackerCategoryStoreError.failedToFetchCategory
        }
    }
    
    func fetchOrCreateCategory(by title: String) throws -> TrackerCategoryCoreData {
        if let existingCategory = try fetchCategory(by: title) {
            return existingCategory
        }
        
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.title = title
        
        do {
            try context.save()
        } catch {
            throw TrackerCategoryStoreError.failedToCreateCategory
        }
        
        return newCategory
    }
}
