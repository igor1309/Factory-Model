//
//  Worker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Worker {
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

extension Worker: Comparable {
    public static func < (lhs: Worker, rhs: Worker) -> Bool {
        lhs.position < rhs.position
            && lhs.name < rhs.name
    }
}
