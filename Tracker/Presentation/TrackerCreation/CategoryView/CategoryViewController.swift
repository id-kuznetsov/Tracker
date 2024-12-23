//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 27.11.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Constants
    
    // MARK: - Public Properties
    
    weak var delegate: CategoryViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let trackerStorage = TrackerStorageService.shared
    
    private lazy var categoriesIsEmptyPlaceholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Tracker Placeholder",
            message: """
                Привычки и события можно
                объединить по смыслу
                """
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    private lazy var tableView: TrackerTableView = {
        let tableView = TrackerTableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
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

    // MARK: - Actions
    
    @objc
    private func didTapDoneButton() {
        let newCategoryViewController = NewCategoryViewController()
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func checkCategories() {
        let categories = trackerStorage.getCategoriesCount()
        let hasCategories = categories != 0
        
        if hasCategories {
            showEmptyPlaceholderView(state: false)
            tableView.isHidden = false
        } else {
            showEmptyPlaceholderView(state: true)
            tableView.isHidden = true
        }
    }
    
    private func showEmptyPlaceholderView(state: Bool) {
        if state {
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
        view.addSubviews([tableView, doneButton])
        [tableView, doneButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.backgroundColor = .ypWhite
        tableView.backgroundColor = .ypBackground
        title = "Категория"
        
        NSLayoutConstraint.activate(
            tableViewConstraints() +
            doneButtonConstraints()
        )
    }
    
    private func tableViewConstraints() -> [NSLayoutConstraint] {
        [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
         tableView.heightAnchor.constraint(equalToConstant: CGFloat(trackerStorage.getCategoriesCount() * 75))
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
    
    private func placeholderViewConstraints() -> [NSLayoutConstraint] {
        [categoriesIsEmptyPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         categoriesIsEmptyPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }
}

// MARK: - Extensions

// MARK: UITableViewDataSource

extension CategoryViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerStorage.getCategoriesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        
        cell.textLabel?.text = "Важное" // TODO: trackerStorage.getCategory(at: indexPath)

        cell.backgroundColor = .ypBackground
        return cell
    }
}

// MARK: UITableViewDelegate

extension CategoryViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.allowsSelection = false
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        delegate?.showSelectedCategory(category: cell.textLabel?.text ?? "Без категории")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

// MARK: CategoryViewCellDelegate



