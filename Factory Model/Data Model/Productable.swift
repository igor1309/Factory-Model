//
//  Productable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.08.2020.
//

import Foundation

protocol Productable {
    
    //  MARK: Qty
    
    var salesQty: Double { get }
    var productionQty: Double { get }
    
    
    //  MARK: Revenue & Avg Price
    
    var revenueExVAT: Double { get }
    var revenueWithVAT: Double { get }
    
    var avgPriceExVAT: Double { get }
    var avgPriceWithVAT: Double { get }
    
    
    //  MARK: Costs per Unit
    
    var ingredientsExVAT: Double { get }
    var ingredientsExVATPercentage: Double { get }
    var ingredientsExVATPercentageStr: String { get }

    //  MARK: FINISH THIS
    var salaryWithTax: Double { get }
    var salaryWithTaxPercentage: Double { get }
    var salaryWithTaxPercentageStr: String { get }

    //  MARK: FINISH THIS
    var depreciationWithTax: Double { get }
    var depreciationWithTaxPercentage: Double { get }
    var depreciationWithTaxPercentageStr: String { get }

    var utilitiesExVAT: Double { get }
    var utilitiesExVATPercentage: Double { get }
    var utilitiesExVATPercentageStr: String { get }
    var utilitiesWithVAT: Double { get }
    
    ///  Full Unit Cost
    var cost: Double { get }
    
    
    //  MARK: Costs for all sold Products
    
    var salesIngrediensExVAT: Double { get }
    
    var salesSalaryWithTax: Double { get }
    
    var salesUtilitiesExVAT: Double { get }
    
    var salesUtilitiesWithVAT: Double { get }
    
    var salesCostExVAT: Double { get }
    
    var cogs: Double { get }
    
    
    //  MARK: Costs for all produced Products
    
    var productionIngrediensExVAT: Double { get }
    
    var productionSalaryWithTax: Double { get }
    
    var productionUtilitiesExVAT: Double { get }
    
    var productionUtilitiesWithVAT: Double { get }
    
    var productionCostExVAT: Double { get }
    
    
    //  MARK: Margin
    // NOT REALLY MARGIN???
    var margin: Double { get }
    
    var totalMargin: Double { get }
    
    var marginPercentage: Double { get }
    
    
    //  MARK: Inventory
    
    var initialInventory: Double { get set }
    var closingInventory: Double { get }
    
}

extension Productable {
    
    //  MARK: Avg Price
    
    var avgPriceExVAT: Double {
        salesQty > 0 ? revenueExVAT / salesQty : 0
    }
    var avgPriceWithVAT: Double {
        salesQty > 0 ? revenueWithVAT / salesQty : 0
    }
    
    
    //  MARK: Costs per Unit
    
    var ingredientsExVATPercentage: Double {
        cost > 0 ? ingredientsExVAT / cost : 0
    }
    var ingredientsExVATPercentageStr: String {
        ingredientsExVATPercentage.formattedPercentageWith1Decimal
    }
    var salaryWithTaxPercentage: Double {
        cost > 0 ? salaryWithTax / cost : 0
    }
    var salaryWithTaxPercentageStr: String {
        salaryWithTaxPercentage.formattedPercentageWith1Decimal
    }
    var depreciationWithTaxPercentage: Double {
        cost > 0 ? depreciationWithTax / cost : 0
    }
    var depreciationWithTaxPercentageStr: String {
        depreciationWithTaxPercentage.formattedPercentageWith1Decimal
    }
    var utilitiesExVATPercentage: Double {
        cost > 0 ? utilitiesExVAT / cost : 0
    }
    var utilitiesExVATPercentageStr: String {
        utilitiesExVATPercentage.formattedPercentageWith1Decimal
    }
    
    ///  MARK: Full Unit Cost
    
    var cost: Double {
        ingredientsExVAT + salaryWithTax + depreciationWithTax + utilitiesExVAT
    }
    
    
    //  MARK: Costs for all sold Products
    
    var salesIngrediensExVAT: Double {
        salesQty * ingredientsExVAT
    }
    
    var salesSalaryWithTax: Double {
        salesQty * salaryWithTax
    }
    
    var salesUtilitiesExVAT: Double {
        salesQty * utilitiesExVAT
    }
    
    var salesUtilitiesWithVAT: Double {
        salesQty * utilitiesWithVAT
    }
    
    var salesCostExVAT: Double {
        salesQty * cost
    }
    
    var cogs: Double {
        salesQty * cost
    }
    
    
    //  MARK: Costs for all produced Products
    
    var productionIngrediensExVAT: Double {
        productionQty * ingredientsExVAT
    }
    
    var productionSalaryWithTax: Double {
        productionQty * salaryWithTax
    }
    
    var productionUtilitiesExVAT: Double {
        productionQty * utilitiesExVAT
    }
    
    var productionUtilitiesWithVAT: Double {
        productionQty * utilitiesWithVAT
    }
    
    var productionCostExVAT: Double {
        productionQty * cost
    }
    
    
    //  MARK: Margin
    // NOT REALLY MARGIN???
    var margin: Double {
        avgPriceExVAT - cost
    }
    
    var totalMargin: Double {
        revenueExVAT - cogs
    }
    
    var marginPercentage: Double {
        revenueExVAT > 0 ? (1 - cogs/revenueExVAT) : 0
    }
    
        
    //  MARK: Closing Inventory
    
    var closingInventory: Double {
        initialInventory + productionQty - salesQty
    }

}

extension Base: Productable {
    
    //  MARK: Qty
    
    var salesQty: Double {
        products
            .reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.salesQty}
    }
    var productionQty: Double {
        products
            /// умножить количество первичного продукта в упаковке (baseQty) на производимое количество (productionQty)
            .reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.productionQty }
    }
    
    
    //  MARK: Revenue
    
    var revenueExVAT: Double {
        products.reduce(0) { $0 + $1.revenueExVAT }
    }
    var revenueWithVAT: Double {
        products.reduce(0) { $0 + $1.revenueWithVAT }
    }
    
    
    //  MARK: Costs per Unit
    
    var ingredientsExVAT: Double {
        recipes
            .map(\.ingredientsExVAT)
            .reduce(0, +)
    }
    
    //  MARK: - FINISH THIS
    var salaryWithTax: Double { 1 }
    
    //  MARK: - FINISH THIS
    var depreciationWithTax: Double { 0.5 }
    
    //  MARK: Utilities per Unit
    
    var utilitiesExVAT: Double {
        utilities
            .reduce(0) { $0 + $1.priceExVAT }
    }
    var utilitiesWithVAT: Double {
        utilities
            .reduce(0) { $0 + $1.priceExVAT * (1 + $1.vat) }
    }
    
}


extension Product: Productable {
    
    //  MARK: Qty
    
    var salesQty: Double {
        sales.reduce(0) { $0 + $1.qty }
    }
    
    
    //  MARK: Revenue
    
    var revenueExVAT: Double {
        sales.reduce(0) { $0 + $1.revenueExVAT }
    }
    var revenueWithVAT: Double {
        sales.reduce(0) { $0 + $1.revenueWithVAT }
    }

    
    //  MARK: Costs per Unit
    
    var ingredientsExVAT: Double {
        (base?.ingredientsExVAT ?? 0) * baseQtyInBaseUnit
    }
    var salaryWithTax: Double {
        (base?.salaryWithTax ?? 0) * baseQtyInBaseUnit
    }
    var depreciationWithTax: Double {
        (base?.depreciationWithTax ?? 0) * baseQtyInBaseUnit
    }
    var utilitiesExVAT: Double {
        (base?.utilitiesExVAT ?? 0) * baseQtyInBaseUnit
    }
    var utilitiesWithVAT: Double {
        (base?.utilitiesWithVAT ?? 0) * baseQtyInBaseUnit
    }


    //  MARK: - FINISH THIS
    var closingInventory: Double { 0 }
}

