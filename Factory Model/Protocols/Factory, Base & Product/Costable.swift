//
//  Costable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol Costable {
    func unitCost(in period: Period) -> Cost
    func сostPerKilo(in period: Period) -> Cost
    func salesCost(in period: Period) -> Cost
    func productionCost(in period: Period) -> Cost
}

typealias BaseOrProduct = CustomUnitable & Ingredientable & Goodable & Salarable & Depreciable & Utilizable

extension Costable where Self: BaseOrProduct {
    func unitCost(in period: Period) -> Cost {
        Cost(
            title: "Unit Cost per \(customUnitString)",
            header: "Unit Cost",
            hasDecimal: true,
            ingredientCostExVAT: ingredientsExVAT(in: period),
            salaryWithTax:       salaryWithTax(in: period),
            depreciation:        depreciationWithTax(in: period),
            utilityCostExVAT:    utilitiesExVAT(in: period)
        )
    }
    
    func сostPerKilo(in period: Period) -> Cost {
        //  MARK: - FINISH THIS
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
        let ingredient =   made(in: period).salesQty * ingredientsExVAT(in: period)
        let salary =       made(in: period).salesQty * salaryWithTax(in: period)
        let depreciation = salesDepreciationWithTax(in: period)
        let utility =      utilitiesExVAT(in: period)
        
        return Cost(
            title: "COGS",
            header: "Sales Cost Structure",
            ingredientCostExVAT: ingredient,
            salaryWithTax: salary,
            depreciation: depreciation,
            utilityCostExVAT: utility
        )
    }
    
    func productionCost(in period: Period) -> Cost {
        let ingredient =   made(in: period).productionQty * ingredientsExVAT(in: period)
        let salary =       made(in: period).productionQty * salaryWithTax(in: period)
        let depreciation = productionDepreciationWithTax(in: period)
        let utility =      productionUtilitiesExVAT(in: period)
        
        return Cost(
            title: "Production Cost",
            header: "Production Cost Structure",
            ingredientCostExVAT: ingredient,
            salaryWithTax: salary,
            depreciation: depreciation,
            utilityCostExVAT: utility
        )
    }
}

extension Factory: Costable {
    func unitCost(in period: Period) -> Cost {
        сostPerKilo(in: period)
    }
    
    //  MARK: - FINISH THIS
    func сostPerKilo(in period: Period) -> Cost {
        Cost(
            title: "Cost TBD per kilo",
            header: "TBD Unit Cost",
            ingredientCostExVAT: 0,
            salaryWithTax: 0,
            depreciation: 0,
            utilityCostExVAT: 0
        )
    }
    
    func salesCost(in period: Period) -> Cost {
        let ingredient =    bases.reduce(0) { $0 + $1.salesCost( in: period).ingredientCostExVAT }
        let salaryWithTax = bases.reduce(0) { $0 + $1.salesCost( in: period).salaryWithTax }
        let depreciation =  bases.reduce(0) { $0 + $1.salesCost( in: period).depreciation }
        let utility =       bases.reduce(0) { $0 + $1.salesCost( in: period).utilityCostExVAT }
        
        return Cost(
            title: "COGS",
            header: "Sales Cost Structure",
            ingredientCostExVAT: ingredient,
            salaryWithTax: salaryWithTax,
            depreciation: depreciation,
            utilityCostExVAT: utility
        )
    }
    
    func productionCost(in period: Period) -> Cost {
        let ingredient =    bases.reduce(0) { $0 + $1.productionCost( in: period).ingredientCostExVAT }
        let salaryWithTax = bases.reduce(0) { $0 + $1.productionCost( in: period).salaryWithTax }
        let depreciation =  bases.reduce(0) { $0 + $1.productionCost( in: period).depreciation }
        let utility =       bases.reduce(0) { $0 + $1.productionCost( in: period).utilityCostExVAT }
        
        return Cost(
            title: "Production Cost",
            header: "Production Cost Structure",
            ingredientCostExVAT: ingredient,
            salaryWithTax: salaryWithTax,
            depreciation: depreciation,
            utilityCostExVAT: utility
        )
    }
}

extension Base: Costable {}
extension Product: Costable {}
