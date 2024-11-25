//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 25.11.2024.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    // MARK: - Private Properties
    private let tableViewSelections = ["Категория", "Расписание"]
    
    private lazy var trackerNameTextField: TrackerTextField = {
        let textField = TrackerTextField(backgroundText: "Введите название трекера")
        return textField
    }()
    
    private lazy var tableView: TrackerTableView = {
        let tableView = TrackerTableView()
        tableView.backgroundColor = .ypBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 75
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createTrackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGrey
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createTrackerButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        print("Create tracker")
        // TODO: Create tracker logic
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Новая привычка"
        view.backgroundColor = .ypWhite
        
        view.addSubviews([trackerNameTextField, tableView, buttonStackView])

        NSLayoutConstraint.activate(
            trackerNameTextFieldConstraints() +
            tableViewSelectionsConstraints() +
            buttonStackViewConstraints()
        )
    }
    
    private func setCreateButtonEnabled(status: Bool) {
        if status {
            createTrackerButton.backgroundColor = .ypBlack
            createTrackerButton.isEnabled = status
        } else {
            createTrackerButton.backgroundColor = .ypGrey
            createTrackerButton.isEnabled = status
        }
        
    }
    
    // MARK: Constraints
    
    private func trackerNameTextFieldConstraints() -> [NSLayoutConstraint] {
        [trackerNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
         trackerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
         trackerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
         trackerNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ]
    }
    
    private func tableViewSelectionsConstraints() -> [NSLayoutConstraint] {
        [tableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         tableView.heightAnchor.constraint(equalToConstant: 150)
         ]
         }
    
    private func buttonStackViewConstraints() -> [NSLayoutConstraint] {
        [buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         
         cancelButton.heightAnchor.constraint(equalToConstant: 60),
         createTrackerButton.heightAnchor.constraint(equalToConstant: 60)
         ]
    }
    }

// MARK: - Extensions

// MARK: UITableViewDataSource

extension NewHabitViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewSelections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = tableViewSelections[indexPath.row]
        cell.backgroundColor = .ypBackground
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension NewHabitViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: переход к выбору категорий или расписания
        if tableViewSelections[indexPath.row] == "Расписание" {
            let scheduleViewController = ScheduleViewController()
            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            present(navigationController, animated: true)
        }
    }
}
