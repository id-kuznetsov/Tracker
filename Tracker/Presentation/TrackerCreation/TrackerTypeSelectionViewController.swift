//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 25.11.2024.
//

import UIKit

final class TrackerTypeSelectionViewController: UIViewController {

    // MARK: - Private Properties
    
    private lazy var newHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapNewHabitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var newIrregularEventButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapNewIrregularEventButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapNewHabitButton() {
        let createNewHabit = NewHabitViewController()
        let navigationController = UINavigationController(rootViewController: createNewHabit)
        present(navigationController, animated: true)
    }
    
    @objc
    private func didTapNewIrregularEventButton() {
        let createNewIrregularEvent = NewIrregularEventViewController()
        let navigationController = UINavigationController(rootViewController: createNewIrregularEvent)
        present(navigationController, animated: true)
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Создание трекера"
        addButtonsInStackView()
        view.addSubview(stackView)
        view.backgroundColor = .ypWhite
        
        NSLayoutConstraint.activate(
            newHabbitButtonConstraints() +
            newIrregularEventButtonConstraints() +
            stackViewConstraints()
        )
    }
    
    private func addButtonsInStackView() {
        stackView.addArrangedSubview(newHabitButton)
        stackView.addArrangedSubview(newIrregularEventButton)
        
    }
    
    
    // MARK: - Constraints
    
    private func newHabbitButtonConstraints() -> [NSLayoutConstraint] {
        [newHabitButton.heightAnchor.constraint(equalToConstant: 60)
        ]
    }
    
    private func newIrregularEventButtonConstraints() -> [NSLayoutConstraint] {
        [newIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ]
    }

    private func stackViewConstraints() -> [NSLayoutConstraint] {
        [stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
    }
    
}

// MARK: - Extensions

