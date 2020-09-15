//
//  Factory+Costs.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation

extension Factory {

    //  MARK: - FINISH THIS PRODUCTION COST
    
    func productionCostExVAT(in period: Period) -> Double {
        bases.reduce(0) { $0 + $1.productionCostExVAT(in: period) }
    }

    //  MARK: - Costs
    
    func cogsExVAT(in period: Period) -> Double {
        salesIngredientCostExVAT(in: period) + productionSalaryWithTax(in: period) + utilitiesExVAT(in: period) + depreciationMonthly
    }
    func cogsExVATPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? cogsExVAT(in: period) / revenue : nil
    }
    
    func salesIngredientCostExVAT(in period: Period) -> Double {
        bases.reduce(0) { $0 + $1.salesIngrediensExVAT(in: period) }
    }
    func salesIngredientCostExVATPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? salesIngredientCostExVAT(in: period) / revenue : nil
    }
    
    func productionIngredientCostExVAT(in period: Period) -> Double {
        bases.reduce(0) { $0 + $1.productionIngredientCostExVAT(in: period) }
    }
    func productionIngredientCostExVATPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? productionIngredientCostExVAT(in: period) / revenue : nil
    }
    
    
    //  MARK: - Salary
    
    func productionSalaryWithTaxPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? productionSalaryWithTax(in: period) / revenue : nil
    }

    func nonProductionSalaryWithTaxPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? nonProductionSalaryWithTax(in: period) / revenue : nil
    }

    
    //  MARK: - Utilities
    
    func utilitiesExVAT(in period: Period) -> Double {
        //  MARK: - FINISH THIS
        bases
            .reduce(0) { $0 + $1.salesQty(in: period) * $1.utilitiesExVAT(in: period) }
    }
    func utilitiesExVATPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? utilitiesExVAT(in: period) / revenue : nil
    }
    
}
