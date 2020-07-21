//
//  Staff.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Staff {
    var department: String {
        get { department_ ?? "Unknown"}
        set { department_ = newValue }
    }
    var division: String {
        get { division_ ?? "Unknown"}
        set { division_ = newValue }
    }
    var position: String {
        get { position_ ?? "Unknown"}
        set { position_ = newValue }
    }

    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var note: String {
        get { note_ ?? "Unknown"}
        set { note_ = newValue }
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
