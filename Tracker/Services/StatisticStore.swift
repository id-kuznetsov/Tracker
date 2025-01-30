//
//  StatisticStore.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 23.01.2025.
//

import Foundation
import CoreData

final class StatisticStore {
    
    enum StatisticStoreError: Error {
        case failedToFetchStatistics
        case failedToSaveStatistics
        case multipleStatisticsFound
    }
    
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = CoreDataManager.shared.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchStatistic() throws -> TrackersStatistics?  {
        let fetchRequest = StatisticCoreData.fetchRequest()
        
        do {
            let statisticsCoreData = try context.fetch(fetchRequest)
            
            guard let statistics = statisticsCoreData.first else {
                print("No statistics found")
                return nil
            }
            
            return TrackersStatistics(
                bestPeriod: Int(statistics.bestPeriod),
                perfectDays: Int(statistics.perfectDays),
                trackersCompleted: Int(statistics.trackersCompleted),
                averageValue: Int(statistics.averageValue)
            )
        } catch {
            throw StatisticStoreError.failedToFetchStatistics
        }
    }
    
    func saveStatistic(_ statistic: TrackersStatistics) throws {
        let fetchRequest = StatisticCoreData.fetchRequest()
        
        do {
            let statisticsCoreData = try context.fetch(fetchRequest)
            
            let savingStatistic: StatisticCoreData
            
            if statisticsCoreData.count > 1 {
                print("Multiple statistics found in the database")
                throw StatisticStoreError.multipleStatisticsFound
            }
            
            if let existingStatistic = statisticsCoreData.first {
                savingStatistic = existingStatistic
            } else {
                savingStatistic = StatisticCoreData(context: context)
            }
            
            savingStatistic.bestPeriod = Int64(statistic.bestPeriod)
            savingStatistic.perfectDays = Int64(statistic.perfectDays)
            savingStatistic.trackersCompleted = Int64(statistic.trackersCompleted)
            savingStatistic.averageValue = Int64(statistic.averageValue)
            
            try context.save()
        } catch {
            throw StatisticStoreError.failedToSaveStatistics
        }
    }
}
