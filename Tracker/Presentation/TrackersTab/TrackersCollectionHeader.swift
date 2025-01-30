//
//  TrackerCollectionHeader.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 26.11.2024.
//

import UIKit

final class TrackersCollectionHeader: UICollectionReusableView {
    
    // MARK: Constants
    
    static let reuseIdentifier = "TrackerCollectionHeader"
    
    // MARK: Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
