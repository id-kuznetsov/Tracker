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

    
    private lazy var tableView: TrackerTableView = {
        let tableView = TrackerTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Public Methods

    // MARK: - Private Methods
    
    @objc
    private func didTapDoneButton() {
        dismiss(animated: true, completion: nil)
        
    }
    
    private func setupUI() {
        view.addSubviews([tableView, doneButton])
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
        cell.textLabel?.text = trackerStorage.trackersMock[indexPath.row].title
        cell.backgroundColor = .ypBackground
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension CategoryViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.allowsSelection = false
        delegate?.showSelectedCategory(category: trackerStorage.trackersMock[indexPath.row].title)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
}

// MARK: CategoryViewCellDelegate



