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
    private let trackerStorage = TrackerStorageService.shared
    private var trackerTitle: String?
    private var selectedCategory: String?
    private var selectedDays = [WeekDay]()
    
    private lazy var trackerNameTextField: TrackerTextField = {
        let textField = TrackerTextField(backgroundText: "Введите название трекера")
        textField.delegate = self
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
    
    private lazy var buttonsStackView: UIStackView = {
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
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        guard let trackerTitle, let selectedCategory else {
            return print("Missing data")
        }
        
        let newTracker = Tracker(
            id: UUID(),
            name: trackerTitle,
            color: .ypSection2, // TODO: add random color
            emoji: "🤔", // TODO: add random emoji
            schedule: selectedDays
        )
        
        trackerStorage.addTracker(newTracker, to: selectedCategory)
        
        view.window?.rootViewController?.dismiss(animated: true)
        
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Новая привычка"
        view.backgroundColor = .ypWhite
        
        view.addSubviews([trackerNameTextField, tableView, buttonsStackView])
        
        NSLayoutConstraint.activate(
            trackerNameTextFieldConstraints() +
            tableViewSelectionsConstraints() +
            buttonsStackViewConstraints()
        )
    }
    
    private func checkFieldsNotEmpty() {
        // TODO: check textField, category and schedule is not empty
        if trackerTitle != nil && selectedCategory != nil && !selectedDays.isEmpty {
            setCreateButtonEnabled(status: true)
        }
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
    
    private func buttonsStackViewConstraints() -> [NSLayoutConstraint] {
        [buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = tableViewSelections[indexPath.row]
        cell.backgroundColor = .ypBackground
        cell.detailTextLabel?.textColor = .ypGrey
        return cell
    }
}

// MARK: UITableViewDelegate

extension NewHabitViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: categoryViewController)
            present(navigationController, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.selectedDaysInSchedule = Set(selectedDays)
            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            scheduleViewController.delegate = self
            present(navigationController, animated: true)
        }
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        trackerTitle = textField.text
        textField.resignFirstResponder()
        checkFieldsNotEmpty()
        return true
    }
}

// MARK: CategoryViewControllerDelegate

extension NewHabitViewController: CategoryViewControllerDelegate {
    func showSelectedCategory(category: String) {
        selectedCategory = category
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))  {
            cell.detailTextLabel?.text = selectedCategory
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        }
        checkFieldsNotEmpty()
    }
}

// MARK: ScheduleViewControllerDelegate

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func showSelectedDays(days: [WeekDay]) {
        selectedDays = days
        let receivedDays = days.map{ $0.shortName }
        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))  {
            if receivedDays.count != 7 {
                cell.detailTextLabel?.text = receivedDays.joined(separator: ", ")
            } else {
                cell.detailTextLabel?.text = "Каждый день"
            }
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        }
        checkFieldsNotEmpty()
    }
}

