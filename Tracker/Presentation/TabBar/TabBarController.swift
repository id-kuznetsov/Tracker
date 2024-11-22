//
//  TabBarController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 22.11.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
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
        trackersViewController.title = "Трекеры"
        trackersViewController.tabBarItem.image = UIImage(systemName: "record.circle.fill")
        trackersViewController.navigationController?.navigationBar.prefersLargeTitles = true

        
        let statisticViewController = StatisticViewController()
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        statisticViewController.title = "Статистика"
        statisticViewController.tabBarItem.image = UIImage(systemName: "hare.fill")
        statisticViewController.navigationController?.navigationBar.prefersLargeTitles = true
           
        self.viewControllers = [trackerNavigationController, statisticNavigationController]
    }
    
    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .ypBlue
        appearance.shadowColor = .ypGrey
        tabBar.standardAppearance = appearance
    }
}