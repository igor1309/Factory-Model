//
//  Factory+Employees.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation

extension Factory {
    
    //  MARK: - Salary
    
    func nonProductionSalaryWithTaxPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? nonProductionSalaryWithTax(in: period) / revenue : nil
    }
    
    func salaryWithTaxPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? salaryWithTax(in: period) / revenue : nil
    }


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
}
