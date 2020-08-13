//
//  Department.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.07.2020.
//

import Foundation

extension Department: Comparable {
    var employees: [Employee] {
        get { (employees_ as? Set<Employee> ?? []).sorted() }
        set { employees_ = Set(newValue) as NSSet }
    }
    
    var headcount: Int { employees.count }

    var salary: Double {
        employees
            .map(\.salary)
            .reduce(0, +)
    }
    var salaryWithTax: Double {
        employees
            .map(\.salaryWithTax)
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
