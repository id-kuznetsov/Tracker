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
        
        let trackerViewController = TrackerViewController()

        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()

        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackerViewController, statisticViewController]
        
        setAppearance()
    }
    
    // MARK: - Private Methods
    
    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypWhite
        appearance.stackedLayoutAppearance.selected.iconColor = .ypBlue

        tabBar.standardAppearance = appearance
    }
}
