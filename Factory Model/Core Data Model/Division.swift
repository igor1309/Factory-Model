//
//  Division.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import Foundation

extension Division: Comparable {
    var departments: [Department] {
        get { (departments_ as? Set<Department> ?? []).sorted() }
        set { departments_ = Set(newValue) as NSSet }
    }
    
    var totalSalary: Double {
        departments
            .flatMap { $0.workers }
            .map { $0.salary}
            .reduce(0, +)
    }
    var totalSalaryWithTax: Double {
        departments
            .flatMap { $0.workers }
            .map { $0.salaryWithTax}
            .reduce(0, +)
    }

    public static func < (lhs: Division, rhs: Division) -> Bool {
        lhs.name < rhs.name
    }
}
