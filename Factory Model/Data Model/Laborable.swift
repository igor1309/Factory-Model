//
//  Laborable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.08.2020.
//

import Foundation

protocol Laborable {
    
    //  MARK: - Headcount
    
    var headcount: Int { get }
    var productionHeadcount: Int { get }
    var nonProductionHeadcount: Int { get }
    
    
    //  MARK: - Salary
    
    func salaryExTax(in period: Period) -> Double
    func salaryWithTax(in period: Period) -> Double
    func productionSalaryWithTax(in period: Period) -> Double
    func nonProductionSalaryWithTax(in period: Period) -> Double
    
    
    //  MARK: - Work Hours
    
    func workHours(in period: Period) -> Double
    func productionWorkHours(in period: Period) -> Double
    func nonProductionWorkHours(in period: Period) -> Double
    
    
    //  MARK: - Salary per Hour
    
    func salaryPerHourWithTax(in period: Period) -> Double
    func productionSalaryPerHourWithTax(in period: Period) -> Double
    func nonProductionSalaryPerHourWithTax(in period: Period) -> Double
    
}

extension Laborable {
    
    //  MARK: - Headcount
    
    var nonProductionHeadcount: Int {
        headcount - productionHeadcount
    }
    
    
    //  MARK: - Salary
    
    func nonProductionSalaryWithTax(in period: Period) -> Double {
        salaryWithTax(in: period) - productionSalaryWithTax(in: period)
    }
    
    
    //  MARK: - Work Hours
    
    func nonProductionWorkHours(in period: Period) -> Double {
        workHours(in: period) - productionWorkHours(in: period)
    }
    
    
    //  MARK: - Salary per Hour
    
    func salaryPerHourWithTax(in period: Period) -> Double {
        let hours = workHours(in: period)
        return hours == 0 ? 0 : salaryWithTax(in: period) / hours
    }
    func productionSalaryPerHourWithTax(in period: Period) -> Double {
        let hours = productionWorkHours(in: period)
        return hours == 0 ? 0 : productionSalaryWithTax(in: period) / hours
    }
    func nonProductionSalaryPerHourWithTax(in period: Period) -> Double {
        let hours = nonProductionWorkHours(in: period)
        return hours == 0 ? 0 : nonProductionSalaryWithTax(in: period) / hours
    }
}


extension Factory: Laborable {
    
    //  MARK: - Headcount
    
    var headcount: Int {
        divisions
            .reduce(0) { $0 + $1.headcount }
    }
    
    var productionHeadcount: Int {
        divisions
            .flatMap(\.departments)
            .filter { $0.type == .production }
            .reduce(0) { $0 + $1.headcount }
    }
    
    
    //  MARK: - Salary
    
    func salaryExTax(in period: Period) -> Double {
        divisions.reduce(0) { $0 + $1.salaryExTax(in: period) }
    }
    func salaryWithTax(in period: Period) -> Double {
        divisions.reduce(0) { $0 + $1.salaryWithTax(in: period) }
    }
    func productionSalaryWithTax(in period: Period) -> Double {
        divisions
            .flatMap(\.departments)
            .filter { $0.type == .production }
            .reduce(0) { $0 + $1.salaryWithTax(in: period) }
    }
    
    
    //  MARK: - Work Hours
    
    func workHours(in period: Period) -> Double {
        divisions
            .flatMap(\.departments)
            //.flatMap(\.employees)
            .reduce(0) { $0 + $1.workHours(in: period) }
    }
    func productionWorkHours(in period: Period) -> Double {
        divisions
            .flatMap(\.departments)
            .filter { $0.type == .production }
            //.flatMap(\.employees)
            .reduce(0) { $0 + $1.workHours(in: period) }
    }
}


extension Division: Laborable {
    
    //  MARK: - Headcount
    
    var headcount: Int {
        departments.reduce(0) { $0 + $1.headcount }
    }
    
    var productionHeadcount: Int {
        departments
            .filter { $0.type == .production }
            .reduce(0) { $0 + $1.headcount }
    }
    
    
    //  MARK: - Salary
    
    func salaryExTax(in period: Period) -> Double {
        departments.reduce(0) { $0 + $1.salaryExTax(in: period) }
    }
    func salaryWithTax(in period: Period) -> Double {
        departments.reduce(0) { $0 + $1.salaryWithTax(in: period) }
    }
    func productionSalaryWithTax(in period: Period) -> Double {
        departments
            .filter { $0.type == .production }
            .flatMap(\.employees)
            .reduce(0) { $0 + $1.salaryWithTax(in: period) }
    }
    
    
    //  MARK: - Work Hours
    
    func workHours(in period: Period) -> Double {
        departments
            .flatMap(\.employees)
            .reduce(0) { $0 + $1.workHours }
    }
    func productionWorkHours(in period: Period) -> Double {
        departments
            .filter { $0.type == .production }
            .flatMap(\.employees)
            .reduce(0) { $0 + $1.workHours }
    }
}


extension Department: Laborable {
    
    //  MARK: - Headcount
    
    var headcount: Int { employees.count }
    
    var productionHeadcount: Int {
        type == .production ? headcount : 0
    }
    
    
    //  MARK: - Salary
    
    func salaryExTax(in period: Period) -> Double {
        employees.reduce(0) { $0 + $1.salaryExTax(in: period) }
    }
    func salaryWithTax(in period: Period) -> Double {
        employees.reduce(0) { $0 + $1.salaryWithTax(in: period) }
    }
    func productionSalaryWithTax(in period: Period) -> Double {
        type == .production ? salaryWithTax(in: period) : 0
    }
    
    
    //  MARK: - Work Hours
    
    func workHours(in period: Period) -> Double {
        employees.reduce(0) { $0 + $1.workHours(in: period) }
    }
    func productionWorkHours(in period: Period) -> Double {
        type == .production ? workHours(in: period) : 0
    }
}
