//
//  TrackerTableView.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 25.11.2024.
//

import UIKit

final class TrackerTableView: UITableView {
    
    init() {
        super.init(frame: .zero, style: .plain)
        layer.cornerRadius = 16
        rowHeight = 75
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .ypWhite
        translatesAutoresizingMaskIntoConstraints = false
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        separatorStyle = .singleLine
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
