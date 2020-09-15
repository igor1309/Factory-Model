//
//  Cost.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import SwiftUI

struct Cost {
    let title: String
    let header: String
    
    let ingredientCostExVAT: Double
    let salaryWithTax: Double
    let depreciation: Double
    let utilityCostExVAT: Double
    
    var costExVAT: Double {
        ingredientCostExVAT + salaryWithTax + depreciation + utilityCostExVAT
    }
    
    //  + … formatted strings
    var costExVATStr: String { costExVAT.formattedGrouped }
    var ingredientCostExVATStr: String { ingredientCostExVAT.formattedGrouped }
    var salaryWithTaxStr: String { salaryWithTax.formattedGrouped }
    var depreciationStr: String { depreciation.formattedGrouped }
    var utilityCostExVATStr: String { utilityCostExVAT.formattedGrouped }
    
    
    //  + …PercentageStr - %% of productionCostExVAT
    var ingredientCostExVATPercentageStr: String {
        costExVAT == 0 ? "" : (ingredientCostExVAT / costExVAT).formattedPercentage
    }
    var salaryWithTaxPercentageStr: String {
        costExVAT == 0 ? "" : (salaryWithTax / costExVAT).formattedPercentage
    }
    var depreciationPercentageStr: String {
        costExVAT == 0 ? "" : (depreciation / costExVAT).formattedPercentage
    }
    var utilityCostExVATPercentageStr: String {
        costExVAT == 0 ? "" : (utilityCostExVAT / costExVAT).formattedPercentage
    }
}

protocol Costable {
    func salesCost(in period: Period) -> Cost
    func productionCost(in period: Period) -> Cost
}

extension Factory: Costable {
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

extension Base: Costable {
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
        let utilityCostExVAT =    utilitiesExVAT(in: period)
        
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

extension Product: Costable {
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
