//
//  NewEventCollectionCell.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 12.12.2024.
//

import UIKit

final class NewEventCollectionCell: UICollectionViewCell {
    // MARK: Constants
    
    static let reuseIdentifier = "NewEventCollectionCell"
    
    // MARK: - Private Properties
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emojiLabel.text = nil
    }
    
    // MARK: - Public Methods
    
    func configureCell(emoji: String) {
        colorView.removeFromSuperview()
        emojiLabel.text = emoji
    }
    
    func configureCell(color: UIColor) {
        emojiLabel.removeFromSuperview()
        colorView.backgroundColor = color
    }
    
    func makeEmojiCellSelected(_ isSelected: Bool) {
        if isSelected {
            contentView.layer.cornerRadius = 16
            contentView.backgroundColor = .ypLightGray
            contentView.layer.masksToBounds = true
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    func makeColorCellSelected(isSelected: Bool, color: UIColor) {
        if isSelected {
            contentView.layer.cornerRadius = 8
            contentView.layer.masksToBounds = true
            contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            contentView.layer.borderWidth = 3
        } else {
            contentView.layer.borderColor = color.cgColor
        }

    }
    
    // MARK: - Private Methods

    private func setCellUI() {
        contentView.addSubviews([emojiLabel, colorView])
        
        NSLayoutConstraint.activate(
            emojiLabelConstraints() +
            colorViewConstraints()
        )
    }

    
    private func emojiLabelConstraints() -> [NSLayoutConstraint] {
        [ emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
    }
    
    private func colorViewConstraints() -> [NSLayoutConstraint] {
        [ colorView.heightAnchor.constraint(equalToConstant: Constraints.colorViewSideSize),
          colorView.widthAnchor.constraint(equalToConstant: Constraints.colorViewSideSize),
          colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
    }
}

extension NewEventCollectionCell {
    enum Constraints {
        static let colorViewSideSize: CGFloat = 40
    }
}

