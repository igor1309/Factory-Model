//
//  Division.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import Foundation
import CoreData

extension Division: Comparable {
    var departments: [Department] {
        get { (departments_ as? Set<Department> ?? []).sorted() }
        set { departments_ = Set(newValue) as NSSet }
    }
    
    var departmentNames: String {
        departments.map(\.name).joined(separator: ", ")
    }
    
    public static func < (lhs: Division, rhs: Division) -> Bool {
        lhs.name < rhs.name
    }
}

