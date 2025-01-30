//
//  TrackersCollectionCell.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 26.11.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {

    // MARK: Constants
    
    static let reuseIdentifier = "TrackersCollectionViewCell"
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Private Properties
    
    private var tracker: Tracker?
    private var trackerIsDone = false
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypWhite
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.frame.size = CGSize(width: 24, height: 24)
        view.layer.cornerRadius = view.frame.size.width / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var trackerCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var trackerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapTrackerButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorTrackerBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.ypGrey.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCellUI()
        setupContextMenu()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emojiLabel.text = nil
        titleLabel.text = nil
        colorTrackerBackground.backgroundColor = nil
        trackerButton.backgroundColor = nil
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapTrackerButton() {
        trackerIsDone.toggle()
        changeButtonIcon(isDone: trackerIsDone)
        delegate?.didTapTrackerButton(self)
    }
    
    // MARK: - Public Methods
    
    func configureCell(with tracker: Tracker, isDone: Bool, doneCount: Int, selectedDate: Date) {
        self.tracker = tracker
        colorTrackerBackground.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        trackerButton.backgroundColor = tracker.color
        trackerIsDone = isDone
        changeButtonIcon(isDone: isDone)
        configureCellCounter(doneCount: doneCount)
        hideTrackerButtonThenDateInFuture(selectedDate)
        isPinnedCell(tracker.isPinned)
    }
    
    func configureCellCounter(doneCount: Int) {
        trackerCountLabel.text = L10n.dDays(doneCount)
    }
    
    // MARK: - Private Methods
    
    private func setupContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        colorTrackerBackground.addInteraction(interaction)
        
    }
    
    private func changeButtonIcon(isDone: Bool) {
        let image = isDone ? UIImage(named: "Done") : UIImage(systemName: "plus")
        trackerButton.setImage(image, for: .normal)
        trackerButton.alpha = isDone ? 0.3 : 1
    }
    
    private func hideTrackerButtonThenDateInFuture(_ date: Date) {
        trackerButton.isHidden = date > Date() ? true : false
    }
    
    private func isPinnedCell(_ state: Bool) {
        pinImageView.isHidden = !state
    }
    
    private func setCellUI() {
        let subviews = [colorTrackerBackground, trackerCountLabel, trackerButton]
        let viewsForMenu = [emojiBackgroundView, emojiLabel, titleLabel, pinImageView]
        colorTrackerBackground.addSubviews(viewsForMenu)
        (subviews + viewsForMenu).forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubviews(subviews)
        
        NSLayoutConstraint.activate(
            colorTrackerBackgroundConstraints() +
            emojiBackgroundViewConstraints() +
            emojiLabelConstraints() +
            titleLabelConstraints() +
            trackerCountLabelConstraints() +
            trackerButtonConstraints() +
            pinImageViewConstraints()
        )
    }
    
    private func colorTrackerBackgroundConstraints() -> [NSLayoutConstraint] {
        [ colorTrackerBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
          colorTrackerBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          colorTrackerBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          colorTrackerBackground.heightAnchor.constraint(equalToConstant: Constraints.colorTrackerBackgroundHeight)
        ]
    }
    
    private func emojiBackgroundViewConstraints() -> [NSLayoutConstraint] {
        [ emojiBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.leading),
          emojiBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constraints.leading),
          emojiBackgroundView.heightAnchor.constraint(equalToConstant: Constraints.emojiViewHeight),
          emojiBackgroundView.widthAnchor.constraint(equalTo: emojiBackgroundView.heightAnchor)
        ]
    }
    
    private func pinImageViewConstraints() -> [NSLayoutConstraint] {
        [ pinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constraints.trailing),
          pinImageView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor)
        ]
    }
    
    private func emojiLabelConstraints() -> [NSLayoutConstraint] {
        [ emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
          emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor)
        ]
    }
    
    private func titleLabelConstraints() -> [NSLayoutConstraint] {
        [ titleLabel.leadingAnchor.constraint(equalTo: colorTrackerBackground.leadingAnchor, constant: Constraints.leading),
          titleLabel.trailingAnchor.constraint(equalTo: colorTrackerBackground.trailingAnchor, constant: Constraints.trailing),
          titleLabel.bottomAnchor.constraint(equalTo: colorTrackerBackground.bottomAnchor, constant: Constraints.trailing)
        ]
    }
    
    private func trackerCountLabelConstraints() -> [NSLayoutConstraint] {
        [ trackerCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.leading),
          trackerCountLabel.centerYAnchor.constraint(equalTo: trackerButton.centerYAnchor)
        ]
    }
    
    private func trackerButtonConstraints() -> [NSLayoutConstraint] {
        [ trackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constraints.trailing),
          trackerButton.topAnchor.constraint(equalTo: colorTrackerBackground.bottomAnchor, constant: Constraints.buttonTop),
          trackerButton.heightAnchor.constraint(equalToConstant: Constraints.buttonHeight),
          trackerButton.widthAnchor.constraint(equalTo: trackerButton.heightAnchor)
        ]
    }
}

extension TrackersCollectionViewCell {
    enum Constraints {
        static let leading: CGFloat = 12
        static let trailing: CGFloat = -12
        static let emojiViewHeight: CGFloat = 24
        static let colorTrackerBackgroundHeight: CGFloat = 90
        static let buttonHeight: CGFloat = 34
        static let buttonTop: CGFloat = 8
    }
}

// MARK: UIContextMenuInteractionDelegate

extension TrackersCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let tracker = self.tracker else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let pinMessage = tracker.isPinned ? L10n.Trackers.MenuUnpin.title : L10n.Trackers.MenuPin.title
            let pinAction = UIAction(
                title: pinMessage
            ) { [weak self] _ in
                self?.delegate?.setPinnedTracker(tracker, isPinned: !tracker.isPinned)
            }
            
            let editAction = UIAction(title: L10n.Trackers.MenuEdit.title) { [weak self] _ in
                self?.delegate?.editTrackerAction(for: tracker)
            }
            
            let deleteAction = UIAction(
                title: L10n.Trackers.MenuDelete.title,
                attributes: .destructive
            ) { [weak self] _ in
                self?.delegate?.deleteTrackerAction(for: tracker)
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
}
