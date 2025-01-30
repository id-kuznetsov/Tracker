//
//  FilterViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 27.11.2024.
//

import UIKit

final class FilterViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: FilterViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let allFilters = TrackersFilter.allCases
    private var lastSelectedFilter: TrackersFilter?
    private var lastSelectedFilterTitle = AppStateManager.shared.selectedFilter
    
    private lazy var tableView: TrackerTableView = {
        let tableView = TrackerTableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75.5
        tableView.tableHeaderView = UIView()
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        lastSelectedFilter = allFilters.first(where: { $0.title == lastSelectedFilterTitle })
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = .ypWhite
        tableView.backgroundColor = .ypBackground
        title = L10n.Trackers.filters
        
        NSLayoutConstraint.activate(tableViewConstraints())
    }
    
    // MARK: Constraints
    
    private func tableViewConstraints() -> [NSLayoutConstraint] {
        let heightConstraint = tableView.heightAnchor.constraint(lessThanOrEqualToConstant: CGFloat(75 * allFilters.count))
        
        return [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                heightConstraint
        ]
    }
}

// MARK: - Extensions

// MARK: UITableViewDataSource

extension FilterViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        
        cell.selectionStyle = .none
        
        let filter = allFilters[indexPath.row]
        cell.textLabel?.text = filter.title
        
        if filter == lastSelectedFilter {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.backgroundColor = .ypBackground
        return cell
    }
}

// MARK: UITableViewDelegate

extension FilterViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<allFilters.count {
            let currentIndexPath = IndexPath(row: row, section: 0)
            tableView.cellForRow(at: currentIndexPath)?.accessoryType = .none
        }
        
        let selectedFilter = allFilters[indexPath.row]
        AppStateManager.shared.selectedFilter = selectedFilter.title
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.allowsSelection = false
        
        delegate?.updateFilter(allFilters[indexPath.row])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
