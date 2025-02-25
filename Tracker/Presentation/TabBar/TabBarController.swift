//
//  TabBarController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 22.11.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: Constants
    
    enum Constants {
        static let trackerTitle = L10n.trackers
        static let statisticTitle = L10n.statistics
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabs()
        setAppearance()
    }
    
    // MARK: - Private Methods
    
    private func setTabs() {
        let trackersViewController = TrackersViewController()
        let trackerNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersViewController.title = Constants.trackerTitle
        trackersViewController.tabBarItem.image = UIImage(systemName: "record.circle.fill")
        trackersViewController.navigationController?.navigationBar.prefersLargeTitles = true
        
        let statisticViewModel = StatisticViewModel()
        let statisticViewController = StatisticViewController(viewModel: statisticViewModel)
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        statisticViewController.title = Constants.statisticTitle
        statisticViewController.tabBarItem.image = UIImage(systemName: "hare.fill")
        statisticViewController.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.viewControllers = [trackerNavigationController, statisticNavigationController]
    }
    
    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .ypBlue
        appearance.backgroundColor = .ypWhite
        tabBar.layer.borderWidth = 1
        appearance.shadowColor = .ypTabBarBorder
        tabBar.layer.borderColor = UIColor.ypTabBarBorder.cgColor
        appearance.backgroundColor = .ypWhite
        tabBar.standardAppearance = appearance
    }
}
