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
    
    var salary: Double { get }
    var salaryWithTax: Double { get }
    var productionSalaryWithTax: Double { get }
    var nonProductionSalaryWithTax: Double { get }
    
    
    //  MARK: - Work Hours
    
    var workHours: Double { get }
    var productionWorkHours: Double { get }
    var nonProductionWorkHours: Double { get }
    
    
    //  MARK: - Salary per Hour
    
    var salaryPerHourWithTax: Double { get }
    var productionSalaryPerHourWithTax: Double { get }
    var nonProductionSalaryPerHourWithTax: Double { get }
    
}

extension Laborable {
    
    //  MARK: - Headcount
    
    var nonProductionHeadcount: Int {
        headcount - productionHeadcount
    }
    
    
    //  MARK: - Salary
    
    var nonProductionSalaryWithTax: Double {
        salaryWithTax - productionSalaryWithTax
    }
    
    
    //  MARK: - Work Hours
    
    var nonProductionWorkHours: Double {
        workHours - productionWorkHours
    }
    
    
    //  MARK: - Salary per Hour
    
    var salaryPerHourWithTax: Double {
        workHours == 0 ? 0 : salaryWithTax / workHours
    }
    var productionSalaryPerHourWithTax: Double {
        productionWorkHours == 0 ? 0 : productionSalaryWithTax / productionWorkHours
    }
    var nonProductionSalaryPerHourWithTax: Double {
        nonProductionWorkHours == 0 ? 0 : nonProductionSalaryWithTax / nonProductionWorkHours
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
    
    //    var nonProductionHeadcount: Int {
    //        headcount - productionHeadcount
    //    }
    
    
    //  MARK: - Salary
    
    var salary: Double {
        divisions
            //            .flatMap(\.departments)
            //            .flatMap(\.employees)
            .map(\.salary)
            .reduce(0, +)
    }
    var salaryWithTax: Double {
        divisions
            //            .flatMap(\.departments)
            //            .flatMap(\.employees)
            .map(\.salaryWithTax)
            .reduce(0, +)
    }
    var productionSalaryWithTax: Double {
        divisions
            .flatMap(\.departments)
            .filter { $0.type == .production }
            .flatMap(\.employees)
            .reduce(0) { $0 + $1.salaryWithTax }
    }
    //    var nonProductionSalaryWithTax: Double {
    //        salaryWithTax - productionSalaryWithTax
    //    }
    
    
    //  MARK: Work Hours
    
    var workHours: Double {
        divisions
            .flatMap(\.departments)
            .flatMap(\.employees)
            .reduce(0) { $0 + $1.workHours }
    }
    var productionWorkHours: Double {
        divisions
            .flatMap(\.departments)
            .filter { $0.type == .production }
            .flatMap(\.employees)
            .reduce(0) { $0 + $1.workHours }
    }
    //    var nonProductionWorkHours: Double {
    //        workHours - productionWorkHours
    //    }
    
    
    //  MARK: per Hour
    
    //    var salaryPerHourWithTax: Double {
    //        workHours == 0 ? 0 : salaryWithTax / workHours
    //    }
    //    var productionSalaryPerHourWithTax: Double {
    //        productionWorkHours == 0 ? 0 : productionSalaryWithTax / productionWorkHours
    //    }
    //    var nonProductionSalaryPerHourWithTax: Double {
    //        nonProductionWorkHours == 0 ? 0 : nonProductionSalaryWithTax / nonProductionWorkHours
    //    }
}
