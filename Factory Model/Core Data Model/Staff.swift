//
//  Staff.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Staff {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    
    var position: String {
        get { position_ ?? "Unknown"}
        set { position_ = newValue }
    }
    var department: String {
        get { department_ ?? "Unknown"}
        set { department_ = newValue }
    }
    var division: String {
        get { division_ ?? "Unknown"}
        set { division_ = newValue }
    }
    
    var salaryWithTax: Double {
        salary * 1.302
    }
    
    var idd: String {
        [department, position]
            .filter { !$0.isEmpty}
            .joined(separator: ": ")
    }
}

extension Staff: Comparable {
    public static func < (lhs: Staff, rhs: Staff) -> Bool {
        lhs.division < rhs.division
            && lhs.department < rhs.department
            && lhs.position < rhs.position
            && lhs.name < rhs.name
    }
    
    
}
