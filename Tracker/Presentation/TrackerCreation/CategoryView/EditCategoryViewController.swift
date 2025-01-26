//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 26.01.2025.
//

import UIKit

final class EditCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: EditCategoryViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var categoryTitle: String?
    private var previousCategoryTitle: String?
    
    private lazy var categoryNameTextField: TrackerTextField = {
        let textField = TrackerTextField(backgroundText: L10n.CategoryCreation.placeholderTitle)
        textField.delegate = self
        return textField
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        label.textAlignment = .center
        label.text = L10n.TrackerCreation.titleLimitText
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
        button.setTitle(L10n.readyButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(categoryToEdit: String) {
        super.init(nibName: nil, bundle: nil)
        categoryTitle = categoryToEdit
        previousCategoryTitle = categoryToEdit
        setCategoryName(categoryToEdit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapDoneButton() {
        guard let categoryTitle, let previousCategoryTitle else {
            return print("Missing data")
        }
        delegate?.didTapDoneButton(newCategoryTitle: categoryTitle, perviousCategoryTitle: previousCategoryTitle)
        
        dismiss(animated: true)
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Редактирование категории"
        view.backgroundColor = .ypWhite
        isShownWarningLabel(false)
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
    
    private func setCategoryName(_ name: String?) {
        categoryNameTextField.text = name
    }
    
    private func isShownWarningLabel(_ status:Bool) {
        warningLabel.isHidden = !status
    }
    
    private func checkFieldNotEmpty() {
        guard let categoryTitle else { return }
        if !categoryTitle.isEmpty  {
            setCreateButtonEnabled(status: true)
        }
    }
    
    private func setCreateButtonEnabled(status: Bool) {
        if status {
            doneButton.backgroundColor = .ypBlack
            doneButton.setTitleColor(.ypWhite, for: .normal)
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

extension EditCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let newText = text.count + string.count - range.length
        categoryTitle = text
        if newText > 38 {
            isShownWarningLabel(true)
            return false
        } else {
            isShownWarningLabel(false)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if let text = textField.text {
            categoryTitle = text
            textField.resignFirstResponder()
            checkFieldNotEmpty()
            return true
        } else {
            return false
        }
    }
}

