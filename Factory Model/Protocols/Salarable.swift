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

extension Factory {}

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

struct Salary {
    
    let salaryWithTax: Double
    let salaryExTax: Double
    
    let productionSalaryWithTax: Double
    let productionSalaryWithTaxPercentage: Double
    
    let nonProductionSalaryWithTax: Double
    let nonProductionSalaryWithTaxPercentage: Double
    
    init(
        revenueExTax: Double,
        salaryWithTax: Double,
        salaryExTax: Double,
        productionSalaryWithTax: Double
    ) {
        self.salaryWithTax = salaryWithTax
        self.salaryExTax = salaryExTax
        self.productionSalaryWithTax = productionSalaryWithTax
        productionSalaryWithTaxPercentage = revenueExTax == 0 ? 0 : productionSalaryWithTax / revenueExTax
        nonProductionSalaryWithTax = salaryWithTax - productionSalaryWithTax
        nonProductionSalaryWithTaxPercentage = revenueExTax == 0 ? 0 : nonProductionSalaryWithTax / revenueExTax
    }
    

    //  MARK: Formatted
    
    var salaryWithTaxStr: String {
        salaryWithTax.formattedGrouped
    }
    var salaryExTaxStr: String {
        salaryExTax.formattedGrouped
    }
    var productionSalaryWithTaxStr: String {
        productionSalaryWithTax.formattedGrouped
    }
    var productionSalaryWithTaxPercentageStr: String {
        productionSalaryWithTaxPercentage.formattedGrouped
    }
    var nonProductionSalaryWithTaxStr: String {
        nonProductionSalaryWithTax.formattedGrouped
    }
    var nonProductionSalaryWithTaxPercentageStr: String {
        nonProductionSalaryWithTaxPercentage.formattedGrouped
    }

}
