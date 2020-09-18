//
//  Tradable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.09.2020.
//

import Foundation

// Tradable - Factory & Base & Product

// Production
struct Production {
    /// Production Weight Netto in Tons
    let weightNetto: Double
    /// Total Production Cost
    let cost: Cost
    /// Production Cost Per Kilo
    let costPerKilo: Cost
    
    var weightNettoStr: String {
        weightNetto.formattedGroupedWith1Decimal
    }
}

// Sales
struct Trade {
    /// Sales Weight Netto in Tons
    let weightNetto: Double
    /// Total Sales PriceCostMargin
    let total: PriceCostMargin
    /// Sales PriceCostMargin per Kilo
    let perKilo: PriceCostMargin
    
    var weightNettoStr: String {
        weightNetto.formattedGroupedWith1Decimal
    }
}

protocol Tradable {
    func produced(in period: Period) -> Production
    func sold(in period: Period) -> Trade
}

extension Base: Tradable {
    func produced(in period: Period) -> Production {
        
        let productionQty = made(in: period).productionQty
        let productionWeightNetto = productionQty * weightNetto / 1_000 / 1_000
        
        //  MARK: - FINISH THIS
        return Production(
            weightNetto: productionWeightNetto,
            cost: Cost(
                title: "",
                header: "",
                hasDecimal: false,
                ingredientCostExVAT: 0,
                salaryWithTax: 0,
                depreciation: 0,
                utilityCostExVAT: 0
            ),
            costPerKilo: Cost(
                title: "",
                header: "",
                hasDecimal: true,
                ingredientCostExVAT: 0,
                salaryWithTax: 0,
                depreciation: 0,
                utilityCostExVAT: 0
            )
        )
    }
    
    func sold(in period: Period) -> Trade {
        
        let salesQty = products.reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.made(in: period).salesQty }
        let salesWeightNettoTons = salesQty * weightNetto / 1_000 / 1_000
        
        //  MARK: - FINISH THIS
        return Trade(
            weightNetto: salesWeightNettoTons,
            total: PriceCostMargin(
                price: 0,
                cost: 0
            ),
            perKilo: PriceCostMargin(
                price: 0,
                cost: 0
            )
        )
    }
}

extension Factory: Tradable {
    func produced(in period: Period) -> Production {
        
        let productionWeightNettoTons = bases.reduce(0) { $0 + $1.produced(in: period).weightNetto }
        
        //  MARK: - FINISH THIS
        return Production(
            weightNetto: productionWeightNettoTons,
            cost: Cost(
                title: "",
                header: "",
                hasDecimal: false,
                ingredientCostExVAT: 0,
                salaryWithTax: 0,
                depreciation: 0,
                utilityCostExVAT: 0
            ),
            costPerKilo: Cost(
                title: "",
                header: "",
                hasDecimal: true,
                ingredientCostExVAT: 0,
                salaryWithTax: 0,
                depreciation: 0,
                utilityCostExVAT: 0
            )
        )
    }
    
    func sold(in period: Period) -> Trade {
        
        let salesWeightNettoTons = bases.reduce(0) { $0 + $1.sold(in: period).weightNetto }
            
        //  MARK: - FINISH THIS
        return Trade(
            weightNetto: salesWeightNettoTons,
            total: PriceCostMargin(
                price: 0,
                cost: 0
            ),
            perKilo: PriceCostMargin(
                price: 0,
                cost: 0
            )
        )
    }
}

extension Product: Tradable {
    func produced(in period: Period) -> Production {
        
        let weightNetto = (base?.weightNetto ?? 0) * baseQtyInBaseUnit
        
        let productionQty = made(in: period).productionQty
        let productionWeightNettoTons = productionQty * weightNetto / 1_000 / 1_000
        
        //  MARK: - FINISH THIS
        return Production(
            weightNetto: productionWeightNettoTons,
            cost: Cost(
                title: "",
                header: "",
                hasDecimal: false,
                ingredientCostExVAT: 0,
                salaryWithTax: 0,
                depreciation: 0,
                utilityCostExVAT: 0
            ),
            costPerKilo: Cost(
                title: "",
                header: "",
                hasDecimal: true,
                ingredientCostExVAT: 0,
                salaryWithTax: 0,
                depreciation: 0,
                utilityCostExVAT: 0
            )
        )
    }
    
    func sold(in period: Period) -> Trade {
        
        let weightNetto = (base?.weightNetto ?? 0) * baseQtyInBaseUnit
        
        let salesQty = made(in: period).salesQty
        let salesWeightNettoTons = salesQty * weightNetto / 1_000 / 1_000
        
        //  MARK: - FINISH THIS
        return Trade(
            weightNetto: salesWeightNettoTons,
            total: PriceCostMargin(
                price: 0,
                cost: 0
            ),
            perKilo: PriceCostMargin(
                price: 0,
                cost: 0
            )
        )
    }
}

