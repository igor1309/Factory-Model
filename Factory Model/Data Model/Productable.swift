//
//  Productable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.08.2020.
//

import Foundation

protocol Productable {
    
    //  MARK: - Qty
    
    func salesQty(in period: Period) -> Double
    func productionQty(in period: Period) -> Double
    
    
    //  MARK: - WeightNetto
    
    var weightNetto: Double { get }
    
    func salesWeightNetto(in period: Period) -> Double
    func productionWeightNetto(in period: Period) -> Double
    
    
    //  MARK: - Revenue & Avg Price
    
    func revenueExVAT(in period: Period) -> Double
    func revenueWithVAT(in period: Period) -> Double
    
    func avgPriceExVAT(in period: Period) -> Double
    func avgPriceWithVAT(in period: Period) -> Double
    
    
    //  MARK: - Ingredients
    
    func ingredientsExVAT(in period: Period) -> Double
    
    
    //  MARK: - Salary
    
    func salaryWithTax(in period: Period) -> Double
    func salaryWithTaxPercentage(in period: Period) -> Double
    func salaryWithTaxPercentageStr(in period: Period) -> String

    //func salesSalaryWithTax(in period: Period) -> Double
    
    func productionSalaryWithTax(in period: Period) -> Double
    
    //  MARK: - Depreciation
    //  MARK: FINISH THIS
    
    func depreciationWithTax(in period: Period) -> Double
    func depreciationWithTaxPercentage(in period: Period) -> Double
    func depreciationWithTaxPercentageStr(in period: Period) -> String

    func salesDepreciationWithTax(in period: Period) -> Double

    func productionDepreciationWithTax(in period: Period) -> Double
    
    
    
    //  MARK: - Utility
    
    func utilitiesExVAT(in period: Period) -> Double

    func productionUtilitiesExVAT(in period: Period) -> Double
    func productionUtilitiesWithVAT(in period: Period) -> Double
    
    func utilitiesWithVAT(in period: Period) -> Double
    
    
    //  Full Unit Cost
    //  MARK: - FINISH THIS
    func cost(in period: Period) -> Double
    
    
    //  MARK: - Costs for all sold Products
    
    func salesCostExVAT(in period: Period) -> Double
    func cogs(in period: Period) -> Double
    
    
    //  MARK: - Costs for all produced Products
    
    func productionCostExVAT(in period: Period) -> Double
    
    
    //  MARK: - Margin
    // NOT REALLY MARGIN???
    func margin(in period: Period) -> Double
    func totalMargin(in period: Period) -> Double
    func marginPercentage(in period: Period) -> Double
    
    
    //  MARK: - Inventory
    
    var initialInventory: Double { get set }
    var closingInventory: Double { get }
    
}

extension Productable {
    
    //  MARK: - WeightNetto
    
    func salesWeightNetto(in period: Period) -> Double {
        salesQty(in: period) * weightNetto / 1_000 / 1_000
    }
    func productionWeightNetto(in period: Period) -> Double {
        productionQty(in: period) * weightNetto / 1_000 / 1_000
    }
    
    
    //  MARK: - Avg Price
    
    func avgPriceExVAT(in period: Period) -> Double {
        let qty = salesQty(in: period)
        return qty > 0 ? revenueExVAT(in: period) / qty : 0
    }
    func avgPriceWithVAT(in period: Period) -> Double {
        let qty = salesQty(in: period)
        return qty > 0 ? revenueWithVAT(in: period) / qty : 0
    }
    
    
    //  MARK: - Costs per Unit
    
    func salaryWithTaxPercentage(in period: Period) -> Double {
        let cst = cost(in: period)
        return cst > 0 ? salaryWithTax(in: period) / cst : 0
    }
    func salaryWithTaxPercentageStr(in period: Period) -> String {
        salaryWithTaxPercentage(in: period).formattedPercentageWith1Decimal
    }
    func depreciationWithTaxPercentage(in period: Period) -> Double {
        let cst = cost(in: period)
        return cst > 0 ? depreciationWithTax(in: period) / cst : 0
    }
    func depreciationWithTaxPercentageStr(in period: Period) -> String {
        depreciationWithTaxPercentage(in: period).formattedPercentageWith1Decimal
    }
    
    ///  MARK: Full Unit Cost
    
    func cost(in period: Period) -> Double {
        ingredientsExVAT(in: period) + salaryWithTax(in: period) + depreciationWithTax(in: period) + utilitiesExVAT(in: period)
    }
    
    
    //  MARK: - Costs for all sold Products
        
    func salesCostExVAT(in period: Period) -> Double {
        salesQty(in: period) * cost(in: period)
    }
    
    func cogs(in period: Period) -> Double {
        salesQty(in: period) * cost(in: period)
    }
    
    
    //  MARK: - Costs for all produced Products
        
    func productionSalaryWithTax(in period: Period) -> Double {
        productionQty(in: period) * salaryWithTax(in: period)
    }
    
    func productionUtilitiesExVAT(in period: Period) -> Double {
        productionQty(in: period) * utilitiesExVAT(in: period)
    }
    
    func productionUtilitiesWithVAT(in period: Period) -> Double {
        productionQty(in: period) * utilitiesWithVAT(in: period)
    }
    
    func productionCostExVAT(in period: Period) -> Double {
        productionQty(in: period) * cost(in: period)
    }
    
    
    //  MARK: - Margin
    // NOT REALLY MARGIN???
    func margin(in period: Period) -> Double {
        avgPriceExVAT(in: period) - cost(in: period)
    }
    
    func totalMargin(in period: Period) -> Double {
        revenueExVAT(in: period) - cogs(in: period)
    }
    
    func marginPercentage(in period: Period) -> Double {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? (1 - cogs(in: period) / revenue) : 0
    }
    
        
    //  MARK: Closing Inventory
    
    func closingInventory(in period: Period) -> Double {
        initialInventory + productionQty(in: period) - salesQty(in: period)
    }

}

extension Base: Productable {
    
    //  MARK: - Qty
    
    func salesQty(in period: Period) -> Double {
        products
            .reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.salesQty(in: period) }
    }
    func productionQty(in period: Period) -> Double {
        products
            /// умножить количество первичного продукта в упаковке (baseQty) на производимое количество (productionQty)
            .reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.productionQty(in: period) }
    }
    
    
    //  MARK: - Revenue
    
    func revenueExVAT(in period: Period) -> Double {
        products.reduce(0) { $0 + $1.revenueExVAT(in: period) }
    }
    func revenueWithVAT(in period: Period) -> Double {
        products.reduce(0) { $0 + $1.revenueWithVAT(in: period) }
    }
    
    
    //  MARK: - Costs per Unit
    
    func ingredientsExVAT(in period: Period) ->  Double {
        recipes.reduce(0) { $0 + $1.ingredientsExVAT }
    }
    
    func salaryWithTax(in period: Period) -> Double {
        //workHours * (factory?.productionSalaryPerHourWithTax(in: period) ?? 0)
        weightNetto * complexity * (factory?.laborCostOf1GramOfBaseProduct(in: period) ?? 0)
    }
        
    //  MARK: - FINISH THIS
    func depreciationWithTax(in period: Period) -> Double { 0.5 }
    func salesDepreciationWithTax(in period: Period) -> Double { 0.5 }
    func productionDepreciationWithTax(in period: Period) -> Double { 0.5 }
    
    
    //  MARK: - Utilities per Unit
    
    func utilitiesExVAT(in period: Period) -> Double {
        utilities.reduce(0) { $0 + $1.priceExVAT }
    }
    func salesUtilitiesExVAT(in period: Period) -> Double {
        utilities.reduce(0) { $0 + $1.priceExVAT }
    }
    func productionUtilitiesExVAT(in period: Period) -> Double {
        utilities.reduce(0) { $0 + $1.priceExVAT }
    }
    func utilitiesWithVAT(in period: Period) -> Double {
        utilities.reduce(0) { $0 + $1.priceExVAT * (1 + $1.vat) }
    }
    
    
    //  MARK: - Inventory
    //  MARK: - FINISH THIS
    var closingInventory: Double { 0 }

}


extension Product: Productable {

    //  MARK: - Qty
    
    func salesQty(in period: Period) -> Double {
        sales.reduce(0) { $0 + $1.salesQty(in: period) }
    }
    
    func productionQty(in period: Period) -> Double {
        productionQty / self.period.hours * period.hours
    }
    
    //  MARK: - WeightNetto
    
    var weightNetto: Double {
        (base?.weightNetto ?? 0) * baseQtyInBaseUnit
    }
    
    
    //  MARK: - Revenue
    
    func revenueExVAT(in period: Period) -> Double {
        sales.reduce(0) { $0 + $1.revenueExVAT(in: period) }
    }
    func revenueWithVAT(in period: Period) -> Double {
        sales.reduce(0) { $0 + $1.revenueWithVAT(in: period) }
    }

    
    //  MARK: - Costs per Unit
    
    func ingredientsExVAT(in period: Period) -> Double {
        (base?.ingredientsExVAT(in: period) ?? 0) * baseQtyInBaseUnit
    }
    func salaryWithTax(in period: Period) -> Double {
        (base?.salaryWithTax(in: period) ?? 0) * baseQtyInBaseUnit
    }
    func depreciationWithTax(in period: Period) -> Double {
        (base?.depreciationWithTax(in: period) ?? 0) * baseQtyInBaseUnit
    }
    func utilitiesExVAT(in period: Period) -> Double {
        (base?.utilitiesExVAT(in: period) ?? 0) * baseQtyInBaseUnit
    }
    func utilitiesWithVAT(in period: Period) -> Double {
        (base?.utilitiesWithVAT(in: period) ?? 0) * baseQtyInBaseUnit
    }


    //  MARK: - FINISH THIS
    func salesDepreciationWithTax(in period: Period) -> Double { 0.5 }
    func productionDepreciationWithTax(in period: Period) -> Double { 0.5 }
    
    
    //  MARK: - Inventory
    //  MARK: - FINISH THIS
    var closingInventory: Double { 0 }
}

