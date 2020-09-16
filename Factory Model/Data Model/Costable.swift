//
//  Costable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol Costable {
    func unitCost(in period: Period) -> Cost
    func salesCost(in period: Period) -> Cost
    func productionCost(in period: Period) -> Cost
}

extension Costable where Self: CustomUnitable & Productable & Ingredientable & Salarable & Depreciable & Utilizable {
    func unitCost(in period: Period) -> Cost {
        Cost(
            title: "Unit Cost per \(customUnitString)",
            header: "Unit Cost",
            hasDecimal: true,
            ingredientCostExVAT: ingredientsExVAT(in: period),
            salaryWithTax: salaryWithTax(in: period),
            depreciation: depreciationWithTax(in: period),
            utilityCostExVAT: utilitiesExVAT(in: period)
        )
    }

    func salesCost(in period: Period) -> Cost {
        let ingredientCostExVAT = salesQty(in: period) * ingredientsExVAT(in: period)
        let salary =              salesQty(in: period) * salaryWithTax(in: period)
        let depreciation =        salesDepreciationWithTax(in: period)
        let utilityCostExVAT =    utilitiesExVAT(in: period)
        
        return Cost(
            title: "COGS",
            header: "Sales Cost Structure",
            ingredientCostExVAT: ingredientCostExVAT,
            salaryWithTax: salary,
            depreciation: depreciation,
            utilityCostExVAT: utilityCostExVAT
        )
    }
    
    func productionCost(in period: Period) -> Cost {
        let ingredientCostExVAT = productionQty(in: period) * ingredientsExVAT(in: period)
        let salary =              productionQty(in: period) * salaryWithTax(in: period)
        let depreciation =        productionDepreciationWithTax(in: period)
        let utilityCostExVAT =    productionUtilitiesExVAT(in: period)
        
        return Cost(
            title: "Production Cost",
            header: "Production Cost Structure",
            ingredientCostExVAT: ingredientCostExVAT,
            salaryWithTax: salary,
            depreciation: depreciation,
            utilityCostExVAT: utilityCostExVAT
        )
    }
}

extension Factory: Costable {
    //  MARK: - FINISH THIS
    func unitCost(in period: Period) -> Cost {
        Cost(
            title: "Unit Cost TBD per kilo",
            header: "TBD Unit Cost",
            ingredientCostExVAT: 0,
            salaryWithTax: 0,
            depreciation: 0,
            utilityCostExVAT: 0
        )
    }
    
    func salesCost(in period: Period) -> Cost {
        let ingredientCostExVAT = bases.reduce(0) { $0 + $1.salesCost( in: period).ingredientCostExVAT }
        let salaryWithTax =       bases.reduce(0) { $0 + $1.salesCost( in: period).salaryWithTax }
        let depreciation =        bases.reduce(0) { $0 + $1.salesCost( in: period).depreciation }
        let utilityCostExVAT =    bases.reduce(0) { $0 + $1.salesCost( in: period).utilityCostExVAT }
        
        return Cost(
            title: "COGS",
            header: "Sales Cost Structure",
            ingredientCostExVAT: ingredientCostExVAT,
            salaryWithTax: salaryWithTax,
            depreciation: depreciation,
            utilityCostExVAT: utilityCostExVAT
        )
    }
    
    func productionCost(in period: Period) -> Cost {
        let ingredientCostExVAT = bases.reduce(0) { $0 + $1.productionCost( in: period).ingredientCostExVAT }
        let salaryWithTax =       bases.reduce(0) { $0 + $1.productionCost( in: period).salaryWithTax }
        let depreciation =        bases.reduce(0) { $0 + $1.productionCost( in: period).depreciation }
        let utilityCostExVAT =    bases.reduce(0) { $0 + $1.productionCost( in: period).utilityCostExVAT }
        
        return Cost(
            title: "Production Cost",
            header: "Production Cost Structure",
            ingredientCostExVAT: ingredientCostExVAT,
            salaryWithTax: salaryWithTax,
            depreciation: depreciation,
            utilityCostExVAT: utilityCostExVAT
        )
    }
}

extension Base: Costable {}
extension Product: Costable {}
