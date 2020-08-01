//
//  Department.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.07.2020.
//

import Foundation

extension Department: Comparable {
    var workers: [Worker] {
        get { (workers_ as? Set<Worker> ?? []).sorted() }
        set { workers_ = Set(newValue) as NSSet }
    }
    
    var headcount: Int { workers.count }

    var totalSalary: Double {
        workers
            .map { $0.salary }
            .reduce(0, +)
    }
    var totalSalaryWithTax: Double {
        workers
            .map { $0.salaryWithTax }
            .reduce(0, +)
    }

    enum DepartmentType: String, CaseIterable {
        case procurement, production, sales, management
    }
    var type: DepartmentType {
        get { DepartmentType(rawValue: type_ ?? DepartmentType.production.rawValue) ?? .production }
        set { type_ = newValue.rawValue }
    }
    
    public static func < (lhs: Department, rhs: Department) -> Bool {
        lhs.name < rhs.name
    }
}
