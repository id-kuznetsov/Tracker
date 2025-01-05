//
//  NewEventViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 30.11.2024.
//

import UIKit

final class NewEventViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let tableViewSelections = ["Категория", "Расписание"]
    private let trackerStorage = TrackerStorageService.shared
    private let emojis = Emojis.emojis
    private let colors = ColorPicker.colors
    private var isHabitEvent: Bool
    private var trackerTitle: String?
    private var selectedCategory: String?
    private var selectedDays = [WeekDay]()
    private var selectedEmoji: String?
    private var selectedEmojiIndex: Int?
    private var selectedColor: UIColor?
    private var selectedColorIndex: Int?
    
    private lazy var trackerNameTextField: TrackerTextField = {
        let textField = TrackerTextField(backgroundText: "Введите название трекера")
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
    
    private lazy var trackerNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trackerNameTextField, warningLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tableView: TrackerTableView = {
        let tableView = TrackerTableView()
        tableView.backgroundColor = .ypBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 76
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createTrackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGrey
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createTrackerButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var emojiAndColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewEventCollectionCell.self, forCellWithReuseIdentifier: NewEventCollectionCell.reuseIdentifier)
        collectionView.register(
            NewEventCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NewEventCollectionHeader.reuseIdentifier
        )
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .ypWhite
        
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialisers
    
    init (isHabit: Bool) {
        self.isHabitEvent = isHabit
        super.init(nibName: nil, bundle: nil)
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
    private func didTapCancelButton() {
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        guard let trackerTitle, let selectedCategory, let selectedEmoji, let selectedColor else {
            return print("Missing data")
        }
        
        let newTracker = Tracker(
            id: UUID(),
            name: trackerTitle,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: isHabitEvent ? selectedDays : WeekDay.allCases,
            isHabit: isHabitEvent
        )
        
        trackerStorage.addTracker(newTracker, to: selectedCategory)
        
        view.window?.rootViewController?.dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = isHabitEvent ? "Новая привычка" : "Новое нерегулярное событие"
        view.backgroundColor = .ypWhite
        
        view.addSubview(scrollView)
        
        setupScrollView()
        
        showWarningLabel(false)
        
        NSLayoutConstraint.activate(
            scrollViewConstraints() +
            trackerNameStackViewConstraints() +
            tableViewSelectionsConstraints() +
            buttonsStackViewConstraints() +
            emojiAndColorCollectionViewConstraints()
        )
    }
    
    private func setupScrollView() {
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([trackerNameStackView, tableView, emojiAndColorCollectionView, buttonsStackView])
        
        [trackerNameStackView, tableView, emojiAndColorCollectionView, buttonsStackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func checkFieldsNotEmpty() {
        guard
            let trackerTitle = trackerTitle, !trackerTitle.isEmpty,
            selectedEmoji != nil,
            selectedColor != nil
        else {
            setCreateButtonEnabled(status: false)
            return
        }
        if isHabitEvent {
            setCreateButtonEnabled(status: !selectedDays.isEmpty)
        } else {
            setCreateButtonEnabled(status: selectedCategory != nil)
        }
    }
    
    private func showWarningLabel(_ status:Bool) {
        warningLabel.isHidden = !status
    }
    
    private func setCreateButtonEnabled(status: Bool) {
        if status {
            createTrackerButton.backgroundColor = .ypBlack
            createTrackerButton.isEnabled = status
        } else {
            createTrackerButton.backgroundColor = .ypGrey
            createTrackerButton.isEnabled = status
        }
    }
    
    private func cellWidthCalculate() -> CGFloat {
        let totalWidth = view.frame.width - Constants.leftInset - Constants.rightInset - Constants.cellSpacing * (CGFloat(Constants.cellCountForRow) - 1)
        return totalWidth / CGFloat(Constants.cellCountForRow)
    }
    
    // MARK: Constraints
    
    private func scrollViewConstraints() -> [NSLayoutConstraint] {
        [scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
         scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         
         contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
         contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
         contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
         contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
         contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
    }
    
    private func trackerNameStackViewConstraints() -> [NSLayoutConstraint] {
        [trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
         trackerNameStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
         trackerNameStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
         trackerNameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ]
    }
    
    private func tableViewSelectionsConstraints() -> [NSLayoutConstraint] {
        [tableView.topAnchor.constraint(equalTo: trackerNameStackView.bottomAnchor, constant: 24),
         tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
         tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
         tableView.heightAnchor.constraint(equalToConstant: isHabitEvent ? 150 : 75)
        ]
    }
    
    private func buttonsStackViewConstraints() -> [NSLayoutConstraint] {
        [buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingButtonInset),
         buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingButtonInset),
         
         cancelButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
         createTrackerButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ]
    }
    
    private func emojiAndColorCollectionViewConstraints() -> [NSLayoutConstraint] {
        let cellWidth = cellWidthCalculate()
        let sectionHeight = Constants.headerHeight + CGFloat(Constants.rowCountForSection) * cellWidth + Constants.topInset + Constants.bottomInset
        let collectionHeight = sectionHeight * CGFloat(SectionInCollection.allCases.count)
        return [emojiAndColorCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
                emojiAndColorCollectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
                emojiAndColorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                emojiAndColorCollectionView.heightAnchor.constraint(equalToConstant: collectionHeight)
        ]
    }
}

// MARK: - Extensions

// MARK: UITableViewDataSource

extension NewEventViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isHabitEvent ? tableViewSelections.count : tableViewSelections.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = tableViewSelections[indexPath.row]
        cell.backgroundColor = .ypBackground
        cell.detailTextLabel?.textColor = .ypGrey
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension NewEventViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewModel = CategoryViewModel()
            let categoryViewController = CategoryViewController(viewModel: viewModel)
            categoryViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: categoryViewController)
            present(navigationController, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.selectedDaysInSchedule = Set(selectedDays)
            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            scheduleViewController.delegate = self
            present(navigationController, animated: true)
        }
    }
}

// MARK: UITextFieldDelegate

extension NewEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let newText = text.count + string.count - range.length
        
        if newText > Constants.maxEventNameLength {
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
            trackerTitle = text
            textField.resignFirstResponder()
            checkFieldsNotEmpty()
            return true
        } else {
            return false
        }
    }
}

// MARK: UICollectionViewDelegate

extension NewEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = SectionInCollection(rawValue: indexPath.section) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewEventCollectionCell else { return }
        switch section {
        case .emoji:
            if selectedEmoji != nil {
                guard let prevIndex = selectedEmojiIndex else { return }
                guard let prevCell = collectionView.cellForItem(at: IndexPath(row: prevIndex, section: 0)) as? NewEventCollectionCell else { return }
                prevCell.makeEmojiCellSelected(false)
            }
            selectedEmoji = emojis[indexPath.item]
            selectedEmojiIndex = indexPath.item
            cell.makeEmojiCellSelected(true)
        case .colors:
            if selectedColor != nil {
                guard let prevIndex = selectedColorIndex else { return }
                guard let prevCell = collectionView.cellForItem(at: IndexPath(row: prevIndex, section: 1)) as? NewEventCollectionCell else { return }
                prevCell.makeColorCellSelected(isSelected: false, color: .clear)
            }
            selectedColor = colors[indexPath.item]
            selectedColorIndex = indexPath.item
            cell.makeColorCellSelected(isSelected: true, color: colors[indexPath.item])
        }
        
        checkFieldsNotEmpty()
    }
    
}

// MARK: UICollectionViewDataSource

extension NewEventViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        SectionInCollection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionInCollection(rawValue: section) else { return 0 }
        switch section {
        case .emoji:
            return emojis.count
        case .colors:
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewEventCollectionCell.reuseIdentifier, for: indexPath) as? NewEventCollectionCell else {
            return UICollectionViewCell()
        }
        
        if let section = SectionInCollection(rawValue: indexPath.section) {
            switch section {
            case .emoji:
                cell.configureCell(emoji: emojis[indexPath.item])
            case .colors:
                cell.configureCell(color: colors[indexPath.item])
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NewEventCollectionHeader.reuseIdentifier,
            for: indexPath
        ) as? NewEventCollectionHeader else {
            return UICollectionReusableView()
        }
        
        let title = SectionInCollection(rawValue: indexPath.section) == .emoji ? SectionInCollection.emoji.title : SectionInCollection.colors.title
        header.configure(with: title)
        return header
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension NewEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = cellWidthCalculate()
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Constants.topInset,
            left: Constants.leftInset,
            bottom: Constants.bottomInset,
            right: Constants.rightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Constants.headerHeight)
    }
}

// MARK: CategoryViewControllerDelegate

extension NewEventViewController: CategoryViewControllerDelegate {
    func showSelectedCategory(category: String) {
        selectedCategory = category
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))  {
            cell.detailTextLabel?.text = selectedCategory
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        }
        checkFieldsNotEmpty()
    }
}

// MARK: ScheduleViewControllerDelegate

extension NewEventViewController: ScheduleViewControllerDelegate {
    func showSelectedDays(days: [WeekDay]) {
        selectedDays = days
        let receivedDays = days.map{ $0.shortName }
        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))  {
            if receivedDays.count != 7 {
                cell.detailTextLabel?.text = receivedDays.joined(separator: ", ")
            } else {
                cell.detailTextLabel?.text = "Каждый день"
            }
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        }
        checkFieldsNotEmpty()
    }
}

// MARK: Constants

private extension NewEventViewController {
    struct Constants {
        static let maxEventNameLength = 38
        
        static let buttonHeight: CGFloat = 60
        static let leadingButtonInset: CGFloat = 20
        static let trailingButtonInset: CGFloat = -20
        
        static let cellCountForRow = 6
        static let rowCountForSection = 3
        static let headerHeight: CGFloat = 39
        static let cellSpacing: CGFloat = 5
        static let leftInset: CGFloat = 18
        static let rightInset: CGFloat = 18
        static let topInset: CGFloat = 24
        static let bottomInset: CGFloat = 24
    }
    
    enum SectionInCollection: Int, CaseIterable {
        case emoji
        case colors
        
        var title: String {
            switch self {
            case .emoji:
                return "Emoji"
            case .colors:
                return "Цвет"
            }
        }
    }
}
