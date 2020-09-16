//
//  Salarable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol Salarable {
    
    //  MARK: Salary
    
    func salaryWithTax(in period: Period) -> Double
    func productionSalaryWithTax(in period: Period) -> Double
}

extension Base: Salarable {
    func salaryWithTax(in period: Period) -> Double {
        weightNetto * complexity * (factory?.laborCostOf1GramOfBaseProduct(in: period) ?? 0)
    }
    
    func productionSalaryWithTax(in period: Period) -> Double {
        productionQty(in: period) * salaryWithTax(in: period)
    }
    
}

extension Product: Salarable {
    func salaryWithTax(in period: Period) -> Double {
        (base?.salaryWithTax(in: period) ?? 0) * baseQtyInBaseUnit
    }
    
    func productionSalaryWithTax(in period: Period) -> Double {
        productionQty(in: period) * salaryWithTax(in: period)
    }
    
}
