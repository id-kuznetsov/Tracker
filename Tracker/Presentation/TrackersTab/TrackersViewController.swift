//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 22.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Constants
    
    // MARK: - Public Properties

    // MARK: - Private Properties
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = [] // TODO: ???
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var placeholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Tracker Placeholder",
            message: "Что будем отслеживать?"
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc private func didTapPlusButton() {
        print("Plus button tapped")
        // TODO: plus button logic
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubview(placeholderView)
        setupNavigationBar()
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(didTapPlusButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
}

    // MARK: - Extensions
