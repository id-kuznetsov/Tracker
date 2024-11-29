//
//  NewEventViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 30.11.2024.
//

import UIKit

final class NewEventViewController: UIViewController {
        
    // MARK: - Private Properties
    private let tableViewSelections = ["Категория", "Расписание"]
    private let trackerStorage = TrackerStorageService.shared
    private var isHabitEvent: Bool
    private var trackerTitle: String?
    private var selectedCategory: String?
    private var selectedDays = [WeekDay]()
    
    private lazy var trackerNameTextField: TrackerTextField = {
        let textField = TrackerTextField(backgroundText: "Введите название трекера")
        textField.delegate = self
        return textField
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        label.textAlignment = .center
        label.text = "Ограничение 38 символов"
        return label
    }()
    
    private lazy var trackerNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trackerNameTextField, warningLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    // MARK: - Initialisers
    
    init (isHabit: Bool) {
        self.isHabitEvent = isHabit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            schedule: isHabitEvent ? WeekDay.allCases : selectedDays
        )
        
        trackerStorage.addTracker(newTracker, to: selectedCategory)
        
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = isHabitEvent ? "Новая привычка" : "Новое нерегулярное событие"
        view.backgroundColor = .ypWhite
        view.addSubviews([trackerNameStackView, tableView, buttonsStackView])
        showWarningLabel(false)
        NSLayoutConstraint.activate(
            trackerNameStackViewConstraints() +
            tableViewSelectionsConstraints() +
            buttonsStackViewConstraints()
        )
    }
    
    private func checkFieldsNotEmpty() {
        guard let trackerTitle = trackerTitle, !trackerTitle.isEmpty else {
            setCreateButtonEnabled(status: false)
            return
        }
        
        if isHabitEvent {
            setCreateButtonEnabled(status: !selectedDays.isEmpty)
        } else {
            setCreateButtonEnabled(status: selectedCategory != nil)
        }
    }
    
    private func showWarningLabel(_ status:Bool) {
        warningLabel.isHidden = !status
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
    
    private func trackerNameStackViewConstraints() -> [NSLayoutConstraint] {
        [trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
         trackerNameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
         trackerNameStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
         trackerNameStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ]
    }
    
    private func tableViewSelectionsConstraints() -> [NSLayoutConstraint] {
        [tableView.topAnchor.constraint(equalTo: trackerNameStackView.bottomAnchor, constant: 24),
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         tableView.heightAnchor.constraint(equalToConstant: isHabitEvent ? 150 : 75)
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

extension NewEventViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isHabitEvent ? tableViewSelections.count : tableViewSelections.count - 1
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

extension NewEventViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // TODO: if categories is not exist yet, redirection to createNewCategory
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

// MARK: UITextFieldDelegate

extension NewEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let newText = text.count + string.count - range.length
        
        if newText > 38 {
            showWarningLabel(true)
            return false
        } else {
            showWarningLabel(false)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if let text = textField.text {
            trackerTitle = text
            textField.resignFirstResponder()
            checkFieldsNotEmpty()
            return true
        } else {
            return false
        }
    }
}

// MARK: CategoryViewControllerDelegate

extension NewEventViewController: CategoryViewControllerDelegate {
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

extension NewEventViewController: ScheduleViewControllerDelegate {
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


