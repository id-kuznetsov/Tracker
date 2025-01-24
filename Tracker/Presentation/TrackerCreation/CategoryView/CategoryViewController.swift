//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 27.11.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: CategoryViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var viewModel: CategoryViewModelProtocol
    
    private lazy var categoriesIsEmptyPlaceholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Tracker Placeholder",
            message: L10n.CategoryCreation.emptyPlaceholderTitle
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    private lazy var tableView: TrackerTableView = {
        let tableView = TrackerTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75.5
        tableView.tableHeaderView = UIView()
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.addCategoryButton, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialisers
    
    init (viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
        viewModel.loadCategories()
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
    private func didTapAddCategoryButton() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        viewModel.categoriesDidChange = { [weak self] categories in
            self?.tableView.reloadData()
            self?.checkCategories()
        }
    }
    
    private func checkCategories() {
        tableView.isHidden = viewModel.shouldShowPlaceholder()
        isShownEmptyPlaceholderView(viewModel.shouldShowPlaceholder())
    }
    
    private func isShownEmptyPlaceholderView(_ isShown: Bool) {
        if isShown {
            view.addSubview(categoriesIsEmptyPlaceholderView)
            NSLayoutConstraint.activate(
                placeholderViewConstraints()
            )
            categoriesIsEmptyPlaceholderView.isHidden = false
        } else {
            categoriesIsEmptyPlaceholderView.isHidden = true
        }
    }
    
    private func setupUI() {
        view.addSubviews([tableView, addCategoryButton])
        [tableView, addCategoryButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.backgroundColor = .ypWhite
        tableView.backgroundColor = .ypBackground
        title = L10n.category
        
        checkCategories()
        
        NSLayoutConstraint.activate(
            tableViewConstraints() +
            doneButtonConstraints()
        )
    }
    
    // MARK: Constraints
    
    private func tableViewConstraints() -> [NSLayoutConstraint] {
        let heightConstraint = tableView.heightAnchor.constraint(lessThanOrEqualToConstant: 75 * CGFloat(viewModel.categoriesCount))
        heightConstraint.priority = .defaultLow
        
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24)
        bottomConstraint.priority = .fittingSizeLevel
        
        return [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                heightConstraint,
                bottomConstraint
        ]
    }
    
    private func doneButtonConstraints() -> [NSLayoutConstraint] {
        [addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
         addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ]
    }
    
    private func placeholderViewConstraints() -> [NSLayoutConstraint] {
        [categoriesIsEmptyPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         categoriesIsEmptyPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }
    
    private func updateTableViewHeight() {
        if let heightConstraint = tableView.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = CGFloat(viewModel.categoriesCount) * 75
        }
        view.layoutIfNeeded()
    }
}

// MARK: - Extensions

// MARK: UITableViewDataSource

extension CategoryViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        
        cell.textLabel?.text = viewModel.getCategoryTitle(at: indexPath)
        
        if viewModel.getCategoryTitle(at: indexPath) == viewModel.getSelectedCategoryTitle() {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.backgroundColor = .ypBackground
        return cell
    }
}

// MARK: UITableViewDelegate

extension CategoryViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<viewModel.categoriesCount {
            let currentIndexPath = IndexPath(row: row, section: 0)
            tableView.cellForRow(at: currentIndexPath)?.accessoryType = .none
         }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.allowsSelection = false
        
        if let categoryTitle = viewModel.getCategoryTitle(at: indexPath) {
            viewModel.saveLastSelectedCategoryTitle(categoryTitle)
            delegate?.showSelectedCategory(category: categoryTitle)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil
        ) { actions in
            let editAction = UIAction(title: L10n.Trackers.MenuEdit.title) { [weak self] _ in
//                let categoryToEdit = self?.viewModel.getCategoryTitle(at: indexPath)
                // TODO: navigation to edit category VC
            }
            let deleteAction = UIAction(title: L10n.Trackers.MenuDelete.title, attributes: .destructive) { [weak self] _ in
                let alert = UIAlertController(title: nil, message: L10n.CategoryCreation.MenuDelete.message, preferredStyle: .actionSheet)
                let deleteAction = UIAlertAction(title: L10n.Trackers.MenuDelete.title, style: .destructive) { [weak self] _ in
                        self?.viewModel.deleteCategory(at: indexPath)
                    }
                let cancelAction = UIAlertAction(title: L10n.Trackers.MenuDelete.cancel, style: .cancel) {_ in }
                    alert.addAction(deleteAction)
                    alert.addAction(cancelAction)
                    self?.present(alert, animated: true)
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func didTapDoneButton(categoryTitle: String) {
        
        let newCategory = TrackerCategory(title: categoryTitle, trackers: [])
        viewModel.addCategory(newCategory)
        
        checkCategories()
        updateTableViewHeight()
    }
}
