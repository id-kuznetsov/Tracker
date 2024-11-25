//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 25.11.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {

    // MARK: - Constants

    // MARK: - Public Properties

    // MARK: - Private Properties

    private lazy var tableView: TrackerTableView = {
        let tableView = TrackerTableView()
        tableView.backgroundColor = .ypBackground
        tableView.register(ScheduleViewCell.self, forCellReuseIdentifier: ScheduleViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 75
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Methods

    // MARK: - Private Methods
    
    @objc
    private func didTapDoneButton() {
        print("Готово")
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.addSubviews([tableView, doneButton])
        view.backgroundColor = .ypWhite
        title = "Расписание"
        
        NSLayoutConstraint.activate(
            tableViewConstraints() +
            doneButtonConstraints()
        )
    }
    
    private func tableViewConstraints() -> [NSLayoutConstraint] {
        [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
         tableView.heightAnchor.constraint(equalToConstant: 525) // TODO: подобрать высоту?
        ]
    }
    
    private func doneButtonConstraints() -> [NSLayoutConstraint] {
        [doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         doneButton.heightAnchor.constraint(equalToConstant: 60),
         doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ]
    }
}

// MARK: - Extensions

// MARK: UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleViewCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let scheduleCell = cell as? ScheduleViewCell else {
            assertionFailure("Construct cell failed")
            return UITableViewCell()
        }
        
//        scheduleCell.delegate = self TODO: delegate
        
        scheduleCell.configCell(at: indexPath)
        return scheduleCell
    }
    
}

// MARK: UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

