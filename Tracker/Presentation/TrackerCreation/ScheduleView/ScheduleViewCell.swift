//
//  ScheduleViewCell.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 25.11.2024.
//

import UIKit

final class ScheduleViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "ScheduleViewCell"
    
    // MARK: - Public Properties
    
        // TODO: delegate for chosen cells
    
    
    // MARK: - Private Properties
    
    private lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.onTintColor = .ypBlue
        switcher.isOn = false
        switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
        return switcher
    }()
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .ypBackground
        backgroundColor = .ypBackground
        selectionStyle = .none
        setCellUI()
    }
    
    func configCell(at indexPath: IndexPath) {
        selectionStyle = .none
        weekDayLabel.text = WeekDay.allCases[indexPath.row].rawValue
    }
    
    // MARK: - Private Methods
    
    @objc
    private func switcherValueChanged() {
        print("switcherValueChanged")
    }
    
    private func setCellUI() {
        contentView.addSubviews([weekDayLabel, switcher])
        
        contentView.backgroundColor = .ypBackground
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate(
            cellConstraint()
        )
        
    }
    
    private func cellConstraint() -> [NSLayoutConstraint] {[
        weekDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        weekDayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ]
    }
        

}
