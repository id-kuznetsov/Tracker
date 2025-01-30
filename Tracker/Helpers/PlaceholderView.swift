//
//  PlaceholderView.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 22.11.2024.
//

import UIKit

final class PlaceholderView: UIView {
    
    // MARK: - Private Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialiser
    
    init(imageName: String, message: String) {
        super.init(frame: .zero)
        
        imageView.image = UIImage(named: imageName)
        textLabel.text = message
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updatePlaceholder(imageName: String, message: String) {
        imageView.image = UIImage(named: imageName)
        textLabel.text = message
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubviews([imageView, textLabel])
        [imageView, textLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(
            setupConstraints()
        )
    }
    
    private func setupConstraints() -> [NSLayoutConstraint] {[
        imageView.topAnchor.constraint(equalTo: topAnchor),
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        imageView.widthAnchor.constraint(equalToConstant: 80),
        imageView.heightAnchor.constraint(equalToConstant: 80),
        
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
        
        heightAnchor.constraint(equalToConstant: 110)
    ]
    }
}
