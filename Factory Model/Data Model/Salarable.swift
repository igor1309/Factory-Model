//
//  Salarable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol Salarable {
    //  MARK: - Salary
    
    //func salaryExTax(in period: Period) -> Double
    func salaryWithTax(in period: Period) -> Double
    func productionSalaryWithTax(in period: Period) -> Double
}

extension Base: Salarable {
    func salaryWithTax(in period: Period) -> Double {
        //workHours * (factory?.productionSalaryPerHourWithTax(in: period) ?? 0)
        weightNetto * complexity * (factory?.laborCostOf1GramOfBaseProduct(in: period) ?? 0)
    }
    
    func productionSalaryWithTax(in period: Period) -> Double {
        productionQty(in: period) * salaryWithTax(in: period)
    }
    
}

extension Product: Salarable {
    func productionSalaryWithTax(in period: Period) -> Double {
        productionQty(in: period) * salaryWithTax(in: period)
    }
    
}
