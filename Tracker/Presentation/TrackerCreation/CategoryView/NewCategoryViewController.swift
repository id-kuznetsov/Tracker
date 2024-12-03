//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 29.11.2024.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Private Properties
    private let trackerStorage = TrackerStorageService.shared
    private var categoryName: String?
    
    private lazy var categoryNameTextField: TrackerTextField = {
        let textField = TrackerTextField(backgroundText: "Введите название категории")
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
    
    private lazy var categoryNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryNameTextField, warningLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapDoneButton() {
        guard let categoryName else {
            return print("Missing data")
        }
        
        let newCategory = TrackerCategory(title: categoryName, trackers: [])
        
        trackerStorage.addCategory(newCategory)
        
        let categoryViewController = CategoryViewController()
        let navigationController = UINavigationController(rootViewController: categoryViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Новая категория"
        view.backgroundColor = .ypWhite
        showWarningLabel(false)
        setCreateButtonEnabled(status: false)
        view.addSubviews([categoryNameStackView, doneButton])
        [categoryNameStackView, doneButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(
            trackerNameStackViewConstraints() +
            doneButtonConstraints()
        )
    }
    
    private func showWarningLabel(_ status:Bool) {
        warningLabel.isHidden = !status
    }
    
    private func checkFieldNotEmpty() {
        guard let categoryName else { return }
        if !categoryName.isEmpty  {
            setCreateButtonEnabled(status: true)
        }
    }
    
    private func setCreateButtonEnabled(status: Bool) {
        if status {
            doneButton.backgroundColor = .ypBlack
            doneButton.isEnabled = status
        } else {
            doneButton.backgroundColor = .ypGrey
            doneButton.isEnabled = status
        }
    }
    
    private func trackerNameStackViewConstraints() -> [NSLayoutConstraint] {
        [categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
         categoryNameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
         categoryNameStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
         categoryNameStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
    }
    
    private func doneButtonConstraints() -> [NSLayoutConstraint] {
        [doneButton.heightAnchor.constraint(equalToConstant: 60),
         doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ]
    }
}

// MARK: UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let newText = text.count + string.count - range.length
        categoryName = text
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
            categoryName = text
            textField.resignFirstResponder()
            checkFieldNotEmpty()
            return true
        } else {
            return false
        }
    }
}

