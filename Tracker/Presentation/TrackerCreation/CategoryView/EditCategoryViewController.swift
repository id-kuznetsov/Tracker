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
    
    @available(*, unavailable)
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
        title = L10n.CategoryCreation.editTitle
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
        [categoryNameTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
         categoryNameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.textFieldTopInset),
         categoryNameStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.textFieldLeadingInset),
         categoryNameStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.textFieldTrailingInset)
        ]
    }
    
    private func doneButtonConstraints() -> [NSLayoutConstraint] {
        [doneButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
         doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingButtonInset),
         doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.trailingButtonInset),
         doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonBottomInset)
        ]
    }
}

// MARK: UITextFieldDelegate

extension EditCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let newText = text.count + string.count - range.length
        categoryTitle = text
        if newText > Constants.maxCategoryNameLength {
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

private extension EditCategoryViewController {
    struct Constants {
        static let maxCategoryNameLength = 38
        
        static let buttonHeight: CGFloat = 60
        static let leadingButtonInset: CGFloat = 20
        static let trailingButtonInset: CGFloat = -20
        static let buttonBottomInset: CGFloat = -16

        static let textFieldTopInset: CGFloat = 24
        static let textFieldHeight: CGFloat = 75
        static let textFieldLeadingInset: CGFloat = 16
        static let textFieldTrailingInset: CGFloat = -16
//        static let headerHeight: CGFloat = 39
//        static let cellSpacing: CGFloat = 5
//        static let leftInset: CGFloat = 18
//        static let rightInset: CGFloat = 18
//        static let topInset: CGFloat = 24
//        static let bottomInset: CGFloat = 24
    }
}

