//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 27.12.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Private Properties

    lazy var pages: [UIViewController] = {
        let firstPage = OnboardingPageViewController(
            onboardingImageName: "OnboardingFirst",
            onboardingTitle: """
                Отслеживайте только 
                то, что хотите
                """
        )
        
        let secondPage = OnboardingPageViewController(
            onboardingImageName: "OnboardingSecond",
            onboardingTitle: """
                Даже если это
                не литры воды и йога
                """
        )
        
        return [firstPage, secondPage]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        
        return pageControl
    }()
    
    private lazy var onboardingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapButton() {
        dismiss(animated: true)
        
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let views = [pageControl, onboardingButton]
        views.forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        dataSource = self
        delegate = self
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            pageControlConstraints() +
            onboardingButtonConstraints()
        )
    }
    
    // MARK: Constraints
    
    private func pageControlConstraints() -> [NSLayoutConstraint] {
        [pageControl.heightAnchor.constraint(equalToConstant: 6),
         pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         pageControl.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -24)
        ]
    }
    
    private func onboardingButtonConstraints() -> [NSLayoutConstraint] {
        [onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         onboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
         onboardingButton.heightAnchor.constraint(equalToConstant: 60)
        ]
    }
    
    
}

// MARK: - Extensions

// MARK: UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages[pages.count - 1]
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages[0]
        }
        
        return pages[nextIndex]
    }
}

// MARK: UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
