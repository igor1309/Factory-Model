//
//  Factory+Employees.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation

extension Factory {
    
    //  MARK: - Division

    var divisions: [Division] {
        get { (divisions_ as? Set<Division> ?? []).sorted() }
        set { divisions_ = Set(newValue) as NSSet }
    }
    var divisionNames: String {
        divisions
            .map(\.name)
            .joined(separator: ", ")
    }

    //  MARK: - Department
    
    var departmentNames: [String] {
        divisions
            .flatMap(\.departments)
            .map(\.name)
            .removingDuplicates()
            .sorted()
    }
    func departmentNames(for division: Division) -> String {
        divisions
            .filter { $0 == division }
            .flatMap(\.departments)
            .map(\.name)
            .removingDuplicates()
            .joined(separator: ", ")
    }
    
    //  MARK: - Employee

    var employees: [Employee] {
        divisions
            .flatMap(\.departments)
            .flatMap(\.employees)
    }
    var employeeByDivision: [String: [Division]] {
        Dictionary(grouping: divisions, by: \.name)
    }
    
    var headcount: Int {
        divisions
            .reduce(0) { $0 + $1.headcount }
    }
    
    func headcount(for division: Division) -> Int {
        divisions
            .filter { $0 == division }
            .flatMap(\.departments)
            .flatMap(\.employees)
            .count
    }
    
    //  MARK: - Salary
    
    var salary: Double {
        divisions
            .flatMap(\.departments)
            .flatMap(\.employees)
            .map(\.salary)
            .reduce(0, +)
    }
    var salaryWithTax: Double {
        divisions
            .flatMap(\.departments)
            .flatMap(\.employees)
            .map(\.salaryWithTax)
            .reduce(0, +)
    }
    var salaryWithTaxPercentage: Double? {
        revenueExVAT > 0 ? salaryWithTax / revenueExVAT : nil
    }

    func salary(for division: Division) -> Double {
        divisions
            .filter { $0 == division }
            .flatMap(\.departments)
            .flatMap(\.employees)
            .map(\.salary)
            .reduce(0, +)
    }
    func salaryWithTax(for division: Division) -> Double {
        divisions
            .filter { $0 == division }
            .flatMap(\.departments)
            .flatMap(\.employees)
            .map(\.salaryWithTax)
            .reduce(0, +)
    }
}
