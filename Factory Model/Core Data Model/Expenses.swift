//
//  Expenses.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Expenses {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var note: String {
        get { note_ ?? "Unknown"}
        set { note_ = newValue }
    }
}

extension Expenses: Comparable {
    public static func < (lhs: Expenses, rhs: Expenses) -> Bool {
        lhs.name < rhs.name
    }
    
    
}
