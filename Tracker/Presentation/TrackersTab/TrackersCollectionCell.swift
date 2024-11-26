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
    
    // MARK: - Private Properties
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypWhite
        label.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        label.frame.size = CGSize(width: 24, height: 24)
        label.layer.cornerRadius = label.frame.size.width / 2
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhite
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
        return button
    }()
    
    private lazy var coloredTrackerBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.ypGrey.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with tracker: Tracker) {
        coloredTrackerBackground.backgroundColor = tracker.color
        
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        trackerButton.backgroundColor = tracker.color
        trackerCountLabel.text = "0 дней" // TODO: счетчик
    }
    
    // MARK: - Private Methods
    
    private func setCellUI() {
        let subviews = [coloredTrackerBackground, emojiLabel, titleLabel, trackerCountLabel, trackerButton]
        subviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubviews(subviews)
        
        NSLayoutConstraint.activate(
            coloredTrackerBackgroundConstraints() +
            emojiLabelConstraints() +
            titleLabelConstraints() +
            trackerCountLabelConstraints() +
            trackerButtonConstraints()
        )
    }
    
    private func coloredTrackerBackgroundConstraints() -> [NSLayoutConstraint] {
        [ coloredTrackerBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
          coloredTrackerBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          coloredTrackerBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          coloredTrackerBackground.heightAnchor.constraint(equalToConstant: 90)
        ]
    }
    
    private func emojiLabelConstraints() -> [NSLayoutConstraint] {
        [ emojiLabel.leadingAnchor.constraint(equalTo: coloredTrackerBackground.leadingAnchor, constant: 12),
          emojiLabel.topAnchor.constraint(equalTo: coloredTrackerBackground.topAnchor, constant: 12),
          emojiLabel.heightAnchor.constraint(equalToConstant: 24)
        ]
    }
    
    private func titleLabelConstraints() -> [NSLayoutConstraint] {
        [ titleLabel.leadingAnchor.constraint(equalTo: coloredTrackerBackground.leadingAnchor, constant: 12),
          titleLabel.bottomAnchor.constraint(equalTo: coloredTrackerBackground.bottomAnchor, constant: -12)
        ]
    }
    
    private func trackerCountLabelConstraints() -> [NSLayoutConstraint] {
        [ trackerCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
          trackerCountLabel.topAnchor.constraint(equalTo: coloredTrackerBackground.bottomAnchor, constant: 16)
        ]
    }
    
    private func trackerButtonConstraints() -> [NSLayoutConstraint] {
        [ trackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
          trackerButton.centerYAnchor.constraint(equalTo: trackerCountLabel.centerYAnchor),
          trackerButton.heightAnchor.constraint(equalToConstant: 34),
          trackerButton.widthAnchor.constraint(equalToConstant: 34)
        ]
    }
}

