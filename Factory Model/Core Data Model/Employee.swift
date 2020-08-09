//
//  Employee.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Employee {
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    
    var position: String {
        get { position_ ?? "Unknown"}
        set { position_ = newValue }
    }
    
    var salaryWithTax: Double {
        salary * 1.302
    }
}

extension Employee: Comparable {
    public static func < (lhs: Employee, rhs: Employee) -> Bool {
        lhs.position < rhs.position
            && lhs.name < rhs.name
    }
}
