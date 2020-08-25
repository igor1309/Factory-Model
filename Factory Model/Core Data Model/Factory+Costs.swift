//
//  Factory+Costs.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation

extension Factory {

    //  MARK: - FINISH THIS PRODUCTION COST
    
    var productionCostExVAT: Double {
        bases
            .reduce(0) { $0 + $1.productionCostExVAT }
    }

    //  MARK: - Costs
    
    var cogsExVAT: Double {
        salesIngredientCostExVAT + productionSalaryWithTax + utilitiesExVAT + depreciationMonthly
    }
    var cogsExVATPercentage: Double? {
        revenueExVAT > 0 ? cogsExVAT / revenueExVAT : nil
    }
    
    var salesIngredientCostExVAT: Double {
        bases.reduce(0) { $0 + $1.salesIngrediensExVAT }
    }
    var salesIngredientCostExVATPercentage: Double? {
        revenueExVAT > 0 ? salesIngredientCostExVAT / revenueExVAT : nil
    }
    
    var ingredientCostExVAT: Double {
        bases
            .flatMap(\.products)
            .compactMap(\.base)
            .reduce(0) { $0 + $1.productionCostExVAT }
    }
    var ingredientCostExVATPercentage: Double? {
        revenueExVAT > 0 ? ingredientCostExVAT / revenueExVAT : nil
    }
    
    //  MARK: - Salary
    
    var productionSalaryWithTax: Double {
        divisions
            .flatMap(\.departments)
            .filter { $0.type == .production }
            .flatMap(\.employees)
            .reduce(0) { $0 + $1.salaryWithTax }
    }
    var productionSalaryWithTaxPercentage: Double? {
        revenueExVAT > 0 ? productionSalaryWithTax / revenueExVAT : nil
    }
    var nonProductionSalaryWithTax: Double {
        salaryWithTax - productionSalaryWithTax
    }
    var nonProductionSalaryWithTaxPercentage: Double? {
        revenueExVAT > 0 ? nonProductionSalaryWithTax / revenueExVAT : nil
    }
    
    
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
    var nonProductionWorkHours: Double {
        workHours - productionWorkHours
    }
    

    //  MARK: per Hour
    
    var salaryPerHourWithTax: Double {
        workHours == 0 ? 0 : salaryWithTax / workHours
    }
    var productionSalaryPerHourWithTax: Double {
        productionWorkHours == 0 ? 0 : productionSalaryWithTax / productionWorkHours
    }
    var nonProductionSalaryPerHourWithTax: Double {
        nonProductionWorkHours == 0 ? 0 : nonProductionSalaryWithTax / nonProductionWorkHours
    }
    
    //  MARK: - Utilities
    
    var utilitiesExVAT: Double {
        //  MARK: - FINISH THIS
        bases
            .reduce(0) { $0 + $1.salesQty * $1.utilitiesExVAT }
    }
    var utilitiesExVATPercentage: Double? {
        revenueExVAT > 0 ? utilitiesExVAT / revenueExVAT : nil
    }
    
}
