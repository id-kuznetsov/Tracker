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
        let viewController = OnboardingViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        // TODO: check first launch or not 
//        let viewController = TabBarController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

