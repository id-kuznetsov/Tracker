//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 25.11.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {

    // MARK: - Public Properties

    weak var delegate: ScheduleViewControllerDelegate?
    
    // MARK: - Private Properties

    var selectedDaysInSchedule =  Set<WeekDay>()
    
    private lazy var tableView: TrackerTableView = {
        let tableView = TrackerTableView()
        tableView.register(ScheduleViewCell.self, forCellReuseIdentifier: ScheduleViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Public Methods

    // MARK: - Private Methods
    
    @objc
    private func didTapDoneButton() {
        let sortedDays = selectedDaysInSchedule.sorted { $0.rawValue < $1.rawValue }
        delegate?.showSelectedDays(days: sortedDays)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.addSubviews([tableView, doneButton])
        [tableView, doneButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.backgroundColor = .ypWhite
        tableView.backgroundColor = .ypBackground
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
         tableView.heightAnchor.constraint(equalToConstant: 525)
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
        
        scheduleCell.delegate = self
        
        let isSelected = selectedDaysInSchedule.contains(WeekDay.allCases[indexPath.row])
        
        scheduleCell.configCell(at: indexPath, isSelected: isSelected)
        return scheduleCell
    }
}

// MARK: UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate  {}

// MARK: ScheduleViewCellDelegate

extension ScheduleViewController: ScheduleViewCellDelegate {
    func daySelected(cell: ScheduleViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        selectedDaysInSchedule.insert(WeekDay.allCases[index])
    }
    
    func dayDeselected(cell: ScheduleViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        if let removeWeekDayIndex = selectedDaysInSchedule.firstIndex(of: WeekDay.allCases[index]) {
            selectedDaysInSchedule.remove(at: removeWeekDayIndex)
        }
    }
}

