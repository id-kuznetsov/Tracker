//
//  StatisticTableViewCell.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 21.01.2025.
//

import UIKit

final class StatisticTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "StatisticTableViewCell"
    
    // MARK: - Private Properties
    
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let gradientLayer = CAGradientLayer()
    private let maskLayer = CAShapeLayer()
    
    // MARK: - Initialisers
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .ypWhite
        selectionStyle = .none
        setCellUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
        setupGradientLayer()
    }
    
    func configCell(with statisticsCard: StatisticsCard) {
        valueLabel.text = "\(statisticsCard.value)"
        titleLabel.text = statisticsCard.title
    }
    
    // MARK: - Private Methods
    
    private func setCellUI() {
        let views = [valueLabel, titleLabel, containerView]
        contentView.addSubviews(views)
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            valueLabelConstraints() +
            titleLabelConstraints() +
            containerViewConstraints()
        )
    }
    
    private func valueLabelConstraints() -> [NSLayoutConstraint] {
        [valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.leading),
         valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.trailing),
         valueLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.topAndBottomInsets)]
    }
    
    private func titleLabelConstraints() -> [NSLayoutConstraint] {
        [titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.leading),
         titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.trailing),
         titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.topAndBottomInsets)]
    }
    
    private func containerViewConstraints() -> [NSLayoutConstraint] {
        [containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing)]
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor.gradientColor0.cgColor,
            UIColor.gradientColor1.cgColor,
            UIColor.gradientColor2.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = Constants.cornerRadius
        
        
        let shape = CAShapeLayer()
        shape.lineWidth = Constants.borderWidth
        shape.path = UIBezierPath(
            roundedRect: containerView.bounds.insetBy(
                dx: Constants.borderWidth,
                dy: Constants.borderWidth
            ),
            cornerRadius: Constants.cornerRadius
        ).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shape
        
        containerView.layer.addSublayer(gradientLayer)
    }
}

extension StatisticTableViewCell {
    enum Constants {
        static let leading: CGFloat = 12
        static let trailing: CGFloat = -12
        static let topAndBottomInsets: CGFloat = 12
        static let spacing: CGFloat = 6
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
    }
}
