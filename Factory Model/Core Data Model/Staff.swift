//
//  Staff.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Staff {
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

extension Staff: Comparable {
    public static func < (lhs: Staff, rhs: Staff) -> Bool {
        lhs.position < rhs.position
            && lhs.name < rhs.name
    }
    
    
}
