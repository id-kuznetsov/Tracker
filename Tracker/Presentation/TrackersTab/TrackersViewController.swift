//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 22.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let trackerStorage = TrackerStorageService.shared
    private let analyticsService = AppMetricaService()
    
    private let calendar = Calendar.current
    private var selectedDate = Date()
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var filterTrackers = TrackersFilter.allTrackers
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = .current
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier)
        collectionView.register(
            TrackersCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackersCollectionHeader.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .ypWhite
        collectionView.bounces = true
        return collectionView
    }()
    
    private lazy var trackersIsEmptyPlaceholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Tracker Placeholder",
            message: L10n.Trackers.EmptyState.title
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    private lazy var searchIsEmptyPlaceholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Search Placeholder",
            message: L10n.Trackers.EmptySearchState.title
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.Trackers.filters, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCollectionForSelectedDate(date: selectedDate)
        addNotificationObserver()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        analyticsService.report(event: .open, screen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        analyticsService.report(event: .close, screen: .main)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapPlusButton() {
        analyticsService.report(event: .click, screen: .main, item: .addTrack)
        let createNewTracker = TrackerTypeSelectionViewController()
        let navigationController = UINavigationController(rootViewController: createNewTracker)
        present(navigationController, animated: true)
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        self.selectedDate = selectedDate
        
        updateCollectionForSelectedDate(date: selectedDate)
    }
    
    @objc
    private func didTapFilterButton() {
        analyticsService.report(event: .click, screen: .main, item: .filter)
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: filterViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: TrackerStorageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateCollectionForSelectedDate(date: selectedDate)
        }
    }
    
    private func updateCollectionForSelectedDate(date: Date) {
        let startOfDay = calendar.startOfDay(for: date)
        completedTrackers = trackerStorage.getAllRecords()
        let allCategories = trackerStorage.getTrackersForDate(startOfDay, completedTrackers: completedTrackers)
        
        categories = filteredCategories(from: allCategories, for: startOfDay)
        
        checkTrackersCategories(isFiltering: !allCategories.isEmpty)
        filterButton.isHidden = allCategories.isEmpty
        collectionView.reloadData()
    }
    
    private func filteredCategories(from allCategories: [TrackerCategory], for startOfDay: Date) -> [TrackerCategory] {
        switch filterTrackers {
        case .allTrackers, .forToday:
            return allCategories
        case .completed:
            return filterCompletedCategories(from: allCategories, for: startOfDay)
        case .uncompleted:
            return filterUncompletedCategories(from: allCategories, for: startOfDay)
        }
    }
    
    private func filterCompletedCategories(from allCategories: [TrackerCategory], for startOfDay: Date) -> [TrackerCategory] {
        return allCategories.map { category in
            TrackerCategory(
                title: category.title,
                trackers: category.trackers.filter { tracker in
                    completedTrackers.contains { $0.id == tracker.id && $0.date == startOfDay }
                }
            )
        }.filter { !$0.trackers.isEmpty }
    }
    
    private func filterUncompletedCategories(from allCategories: [TrackerCategory], for startOfDay: Date) -> [TrackerCategory] {
        return allCategories.map { category in
            TrackerCategory(
                title: category.title,
                trackers: category.trackers.filter { tracker in
                    !completedTrackers.contains { $0.id == tracker.id && $0.date == startOfDay }
                }
            )
        }.filter { !$0.trackers.isEmpty }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupCollectionViewAndFilterButton()
        checkTrackersCategories(isFiltering: false)
    }
    
    private func checkTrackersCategories(isFiltering: Bool) {
        let hasTrackers = categories.contains { !$0.trackers.isEmpty }
        let isSearchEmpty = isFiltering && categories.isEmpty
        
        if hasTrackers {
            togglePlaceholderView(isShown: false, for: trackersIsEmptyPlaceholderView)
            togglePlaceholderView(isShown: false, for: searchIsEmptyPlaceholderView)
            collectionView.isHidden = false
            filterButton.isHidden = false
        } else if isSearchEmpty {
            togglePlaceholderView(isShown: true, for: searchIsEmptyPlaceholderView)
            togglePlaceholderView(isShown: false, for: trackersIsEmptyPlaceholderView)
            filterButton.isHidden = false
        } else {
            togglePlaceholderView(isShown: true, for: trackersIsEmptyPlaceholderView)
            togglePlaceholderView(isShown: false, for: searchIsEmptyPlaceholderView)
            collectionView.isHidden = true
            filterButton.isHidden = true
        }
    }
    
    private func setupCollectionViewAndFilterButton() {
        view.addSubviews([collectionView, filterButton])
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        NSLayoutConstraint.activate(
            collectionViewConstraints() +
            filterButtonConstraints()
        )
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(didTapPlusButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = L10n.searchPlaceholderText
        searchController.searchBar.setValue(L10n.TrackerCreation.cancelButtonTitle, forKey: "cancelButtonText")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func togglePlaceholderView(isShown: Bool, for placeholderView: PlaceholderView) {
        if isShown {
            view.addSubview(placeholderView)
            NSLayoutConstraint.activate(
                placeholderViewConstraints(for: placeholderView)
            )
            placeholderView.isHidden = false
        } else {
            placeholderView.isHidden = true
        }
    }
    
    private func showFilterIsActive(filter: TrackersFilter) {
        switch filter {
        case .allTrackers:
            filterButton.titleLabel?.textColor = .ypWhite
        case .forToday:
            filterButton.titleLabel?.textColor = .ypWhite
        case .completed:
            filterButton.titleLabel?.textColor = .green
        case .uncompleted:
            filterButton.titleLabel?.textColor = .ypRed
        }
    }
    
    private func placeholderViewConstraints(for placeholderView: PlaceholderView) -> [NSLayoutConstraint] {
        [placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }
    
    private func collectionViewConstraints() -> [NSLayoutConstraint] {
        [collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
    
    private func filterButtonConstraints() -> [NSLayoutConstraint] {
        [filterButton.heightAnchor.constraint(equalToConstant: 50),
         filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
         filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
         filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
    }
}

// MARK: - Extensions
// MARK: UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier, for: indexPath) as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        
        let isDone = completedTrackers.contains { record in
            record.id == tracker.id && calendar.isDate(record.date, inSameDayAs: calendar.startOfDay(for: selectedDate))
        }
        
        let doneCount = completedTrackers.filter{ $0.id == tracker.id }.count
        cell.delegate = self
        cell.configureCell(with: tracker, isDone: isDone, doneCount: doneCount, selectedDate: selectedDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackersCollectionHeader.reuseIdentifier,
            for: indexPath
        ) as? TrackersCollectionHeader else {
            return UICollectionReusableView()
        }
        
        header.configure(with: categories[indexPath.section].title)
        
        return header
    }
}

// MARK: UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {}

// MARK: UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let availableWidth = totalWidth - Constants.cellSpacing - Constants.leftInset - Constants.rightInset
        let width = availableWidth / CGFloat(Constants.cellCountForRow)
        return CGSize(width: width, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 16, bottom: 8, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 39)
    }
}

extension TrackersViewController {
    enum Constants {
        static let cellCountForRow = 2
        static let cellHeight: CGFloat = 148
        static let cellSpacing: CGFloat = 9
        static let leftInset: CGFloat = 16
        static let rightInset: CGFloat = 16
    }
}

// MARK: UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            updateCollectionForSelectedDate(date: selectedDate)
            togglePlaceholderView(isShown: false, for: searchIsEmptyPlaceholderView)
            return
        }
        let text = searchText.lowercased()
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let fetchedCategories = trackerStorage.getTrackersForDate(startOfDay, completedTrackers: completedTrackers)
        let filteredCategories = fetchedCategories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return tracker.name.lowercased().contains(text)
            }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        categories = filteredCategories
        collectionView.reloadData()
        
        if categories.isEmpty {
            togglePlaceholderView(isShown: true, for: searchIsEmptyPlaceholderView)
        } else {
            togglePlaceholderView(isShown: false, for: searchIsEmptyPlaceholderView)
        }
    }
}

// MARK: TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {

    func setPinnedTracker(_ tracker: Tracker, isPinned: Bool) {
        trackerStorage.setPinnedTracker(tracker, isPinned: !tracker.isPinned)
    }
    
    func editTrackerAction(for tracker: Tracker) {
        analyticsService.report(event: .click, screen: .main, item: .edit)
        let category = trackerStorage.getCategory(for: tracker) ?? ""
        let doneCount = completedTrackers.filter{ $0.id == tracker.id }.count
        let editTrackerViewController = NewEventViewController(isEditing: true, tracker: tracker, selectedCategory: category, doneCount: doneCount)
        let navigationController = UINavigationController(rootViewController: editTrackerViewController)
        self.present(navigationController, animated: true)
    }
    
    func deleteTrackerAction(for tracker: Tracker) {
        analyticsService.report(event: .click, screen: .main, item: .delete)
        let alert = UIAlertController(title: nil, message: L10n.Trackers.MenuDelete.message, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: L10n.Trackers.MenuDelete.title, style: .destructive) { [weak self] _ in
            self?.trackerStorage.deleteTracker(tracker)
        }
        
        let cancelAction = UIAlertAction(title: L10n.Trackers.MenuDelete.cancel, style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func didTapTrackerButton(_ cell: TrackersCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if selectedDate > Date() {
            return
        }
        analyticsService.report(event: .click, screen: .main, item: .addTrack)
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let trackerRecord = TrackerRecord(id: tracker.id, date: startOfDay)
        
        if completedTrackers.contains(trackerRecord) {
            trackerStorage.removeRecord(trackerRecord)
        } else {
            trackerStorage.addRecord(trackerRecord)
        }
        completedTrackers = trackerStorage.getAllRecords()
        let doneCount = completedTrackers.filter{ $0.id == tracker.id }.count
        cell.configureCellCounter(doneCount: doneCount)
    }
}

extension TrackersViewController: FilterViewControllerDelegate {
    func updateFilter(_ filter: TrackersFilter) {
        filterTrackers = filter
        showFilterIsActive(filter: filter)
        if filterTrackers == .forToday {
            selectedDate = Date()
            datePicker.date = selectedDate
            updateCollectionForSelectedDate(date: selectedDate)
        } else {
            updateCollectionForSelectedDate(date: selectedDate)
        }
    }
}
