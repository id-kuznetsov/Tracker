//
//  TrackerTableView.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 25.11.2024.
//

import UIKit

class TrackerTableView: UITableView {
    
    init() {
        super.init(frame: .zero, style: .plain)
        layer.cornerRadius = 16
        rowHeight = 75
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        backgroundColor = .ypBackground
        translatesAutoresizingMaskIntoConstraints = false
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        separatorStyle = .singleLine
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
