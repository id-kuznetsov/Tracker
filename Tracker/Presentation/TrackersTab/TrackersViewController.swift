//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 22.11.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Constants
    
    // MARK: - Public Properties

    // MARK: - Private Properties
    private let date = Date()
    private let calendar = Calendar.current
    
    private let trackerStorage = TrackerStorageService.shared
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = [] // TODO: ???
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
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
        
        collectionView.backgroundColor = .ypWhite
        
        return collectionView
    }()
    
    private lazy var trackersIsEmptyPlaceholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Tracker Placeholder",
            message: "Что будем отслеживать?"
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    private lazy var searchIsEmptyPlaceholderView: PlaceholderView = {
        let placeholderView = PlaceholderView(
            imageName: "Search Placeholder",
            message: "Ничего не найдено"
        )
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trackerMock = trackerStorage.trackersMock
        categories = trackerMock// TODO: для теста коллекции, убрать перед ревью
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc private func didTapPlusButton() {
        let createNewTracker = TrackerTypeSelectionViewController()
        let navigationController = UINavigationController(rootViewController: createNewTracker)
        present(navigationController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let weekday = calendar.component(.weekday, from: selectedDate)
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
        print("Текущий день недели: \(adjustedWeekday)")
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        setupNavigationBar()
        checkTrackersCategories()
    }
    
    private func checkTrackersCategories() {
        if categories.isEmpty {
            showEmptyPlaceholderView(state: true)
        } else {
            showEmptyPlaceholderView(state: false)
            setupCollectionView()
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate(
            collectionViewConstraints()
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
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func showEmptyPlaceholderView(state: Bool) {
        if state {
            view.addSubview(trackersIsEmptyPlaceholderView)
            NSLayoutConstraint.activate(
                placeholderViewConstraints()
            )
        } else {
            trackersIsEmptyPlaceholderView.isHidden = true
        }
    }
    
    private func placeholderViewConstraints() -> [NSLayoutConstraint] {
        [trackersIsEmptyPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        trackersIsEmptyPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
         ]
    }
    
    private func collectionViewConstraints() -> [NSLayoutConstraint] {
        [collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
}

    // MARK: - Extensions

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
        
        cell.configureCell(with: categories[indexPath.section].trackers[indexPath.row])
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

extension TrackersViewController: UICollectionViewDelegate {
    
}

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
        let stubHeader = TrackersCollectionHeader()
        stubHeader.configure(with: categories[section].title)
        
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let fittingSize = stubHeader.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return CGSize(width: fittingSize.width, height: fittingSize.height)
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

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: search settings
    }
    
    
}
