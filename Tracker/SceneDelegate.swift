//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 21.11.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        if AppStateManager.shared.isFirstLaunch {
            AppStateManager.shared.isFirstLaunch = false
            showOnboarding(tabBarController: tabBarController)
        }
    }
    
    private func showOnboarding(tabBarController: TabBarController) {
        let onboardingViewController = OnboardingViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        onboardingViewController.modalPresentationStyle = .fullScreen
        tabBarController.present(onboardingViewController, animated: true)
    }
}

