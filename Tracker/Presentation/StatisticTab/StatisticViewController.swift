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
    
    private var viewModel: StatisticViewModelProtocol
    
    private lazy var placeholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Statictic Placeholder",
            message: L10n.Statistic.EmptyState.title
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    private lazy var statisticTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: StatisticTableViewCell.reuseIdentifier)
        tableView.rowHeight = Constraints.rowHeight
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCategories()
        setupUI()
        setupBindings()
    }
    
    init (viewModel: StatisticViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        viewModel.statisticDidChange = { [weak self] categories in
            self?.statisticTableView.reloadData()
            self?.checkCategories()
        }
    }
    
    private func checkCategories() {
        isShownEmptyPlaceholderView(viewModel.shouldShowPlaceholder())
        statisticTableView.isHidden = viewModel.shouldShowPlaceholder()
    }
    
    private func isShownEmptyPlaceholderView(_ isShown: Bool) {
        if isShown {
            setupPlaceholderView()
            statisticTableView.isHidden = isShown
            placeholderView.isHidden = !isShown
        } else {
            statisticTableView.isHidden = isShown
            placeholderView.isHidden = !isShown
        }
    }
    
    private func setupPlaceholderView() {
        view.addSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(statisticTableView)
        
        NSLayoutConstraint.activate([
            statisticTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.leading),
            statisticTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constraints.trailing),
            statisticTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statisticTableView.heightAnchor.constraint(equalToConstant: 408)
        ])
    }
}

// MARK: - Extensions
extension StatisticViewController: UITableViewDelegate {}

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.statisticItemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticTableViewCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let statisticCell = cell as? StatisticTableViewCell else {
            assertionFailure("Construct cell failed")
            return UITableViewCell()
        }
      
        let statCard = viewModel.getStatisticCard(at: indexPath.row)
        statisticCell.configCell(with: statCard)
        
        return statisticCell
    }
}

extension StatisticViewController {
    enum Constraints {
        static let leading: CGFloat = 16
        static let trailing: CGFloat = -16
        static let rowHeight: CGFloat = 102
    }
}
