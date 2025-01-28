//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 27.12.2024.
//

import UIKit

final class OnboardingPageViewController: UIViewController {

    // MARK: - Private Properties
    
    private var onboardingImageName: String
    private var onboardingTitle: String
    private lazy var onboardingBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var onboardingTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialisers
    
    init(onboardingImageName: String, onboardingTitle: String) {
        self.onboardingImageName = onboardingImageName
        self.onboardingTitle = onboardingTitle
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

    // MARK: - Private Methods
 
    private func setupUI() {
        onboardingBackgroundImageView.image = UIImage(named: onboardingImageName)
        onboardingTitleLabel.text = onboardingTitle
        let views = [onboardingBackgroundImageView, onboardingTitleLabel]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        view.addSubviews(views)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            imageViewConstraints() +
            labelConstraints()
            )
    }
    
    // MARK: Constraints
    
    private func imageViewConstraints() -> [NSLayoutConstraint] {
        [onboardingBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
         onboardingBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         onboardingBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         onboardingBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
    
    private func labelConstraints() -> [NSLayoutConstraint] {
        [onboardingTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         onboardingTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         onboardingTitleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
         ]
    }
    
}
