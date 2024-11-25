//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 22.11.2024.
//

import UIKit

final class StatisticViewController: UIViewController {

    // MARK: - Constants

    // MARK: - Public Properties

    // MARK: - Private Properties

    private lazy var placeholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Statictic Placeholder",
            message: "Анализировать пока нечего"
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Methods

    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Extensions

