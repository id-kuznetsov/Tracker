//
//  DayWord.swift
//  Tracker
//
//  Created by Ilya Kuznetsov on 27.11.2024.
//

import Foundation

extension Int {
    func dayWord() -> String {
        let reminder10 = self % 10
        let reminder100 = self % 100
        
        if reminder100 >= 11 && reminder100 <= 14 {
            return "дней"
        }
        
        switch reminder10 {
        case 1:
            return "день"
        case 2, 3, 4:
            return "дня"
        default:
            return "дней"
        }
    }
}
