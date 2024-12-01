//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 29.11.2024.
//

import UIKit

final class AddCategoryViewController: UIViewController {

    // MARK: - Private Properties
    
    private lazy var placeholderView: PlaceholderView = {
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
    
    private lazy var addNewCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapNewCategoryButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    func didTapNewCategoryButton() {
        let newCategoryViewController = NewCategoryViewController()
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Категория"
        view.backgroundColor = .ypWhite
        view.addSubviews([placeholderView, addNewCategoryButton])
        
        NSLayoutConstraint.activate(
            placeholderViewConstraints() +
            addNewCategoryButtonConstraints()
        )
    }
    
    private func placeholderViewConstraints() -> [NSLayoutConstraint] {
        [placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }
    
    private func addNewCategoryButtonConstraints() -> [NSLayoutConstraint] {
        [addNewCategoryButton.heightAnchor.constraint(equalToConstant: 60),
         addNewCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         addNewCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         addNewCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ]
    }
}

