//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 21.01.2025.
//

import Foundation

protocol StatisticViewModelProtocol {
    var statisticItemsCount: Int { get }
    var statisticDidChange: Binding<TrackersStatistics>? { get set }
    
    func shouldShowPlaceholder() -> Bool
    func getStatisticCard(at index: Int) -> StatisticsCard
}

final class StatisticViewModel: StatisticViewModelProtocol {
    
    
    // MARK: - Public Properties
    
    let statisticItemsCount: Int = StatisticType.allCases.count
    var statisticDidChange: Binding<TrackersStatistics>?
    
    // MARK: - Private Properties
    
    private let trackerStorage = TrackerStorageService.shared
    private var trackerStatistic: TrackersStatistics?
    
    // MARK: - Initializer
    
    init() {
        setupBindings()
        updateStatistics()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    func shouldShowPlaceholder() -> Bool {
        trackerStorage.getAllRecords().isEmpty
    }
    
    func getStatisticCard(at index: Int) -> StatisticsCard {
        guard let trackerStatistic else {
            return StatisticsCard(title: "", value: 0)
        }
        return StatisticsCard(
            title: StatisticType.allCases[index].title,
            value: trackerStatistic.value(for: StatisticType.allCases[index])
        )
    }
    
    // MARK: - Private Methods
    
    private func updateStatistics() {
        trackerStatistic = trackerStorage.calculateStatistic()
        if let trackerStatistic = trackerStatistic {
            statisticDidChange?(trackerStatistic)
        }
      }
    
    private func setupBindings() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataChanged),
            name: TrackerStorageService.didChangeRecord,
            object: nil
        )
    }
    
    @objc private func handleDataChanged() {
        updateStatistics()
        guard let trackerStatistic = trackerStatistic else { return }
        statisticDidChange?(trackerStatistic)
    }
    
}
