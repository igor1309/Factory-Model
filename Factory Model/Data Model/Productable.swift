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
    
    
    //  MARK: - Revenue & Avg Price
    
    func revenueExVAT(in period: Period) -> Double
    func revenueWithVAT(in period: Period) -> Double
    
    func avgPriceExVAT(in period: Period) -> Double
    func avgPriceWithVAT(in period: Period) -> Double
    
    
    //  MARK: - Ingredients
    
    func ingredientsExVAT(in period: Period) -> Double
    
        
    //  Full Unit Cost
    //  MARK: - FINISH THIS
    func cost(in period: Period) -> Double
    
    
    //  MARK: - Costs for all sold Products
    
    func salesCostExVAT(in period: Period) -> Double
    func cogs(in period: Period) -> Double
    
    
    //  MARK: - Costs for all produced Products
    
    func productionCostExVAT(in period: Period) -> Double
}

extension Productable where Self: Salarable & Depreciable & Utilizable {
    ///  MARK: Full Unit Cost
    
    func cost(in period: Period) -> Double {
        ingredientsExVAT(in: period)
            + salaryWithTax(in: period)
            + depreciationWithTax(in: period)
            + utilitiesExVAT(in: period)
    }
}

extension Productable {
    
    //  MARK: - Avg Price
    
    func avgPriceExVAT(in period: Period) -> Double {
        let qty = salesQty(in: period)
        return qty > 0 ? revenueExVAT(in: period) / qty : 0
    }
    func avgPriceWithVAT(in period: Period) -> Double {
        let qty = salesQty(in: period)
        return qty > 0 ? revenueWithVAT(in: period) / qty : 0
    }
    
        
    //  MARK: - Costs for all sold Products
        
    func salesCostExVAT(in period: Period) -> Double {
        salesQty(in: period) * cost(in: period)
    }
    
    func cogs(in period: Period) -> Double {
        salesQty(in: period) * cost(in: period)
    }
    
    
    //  MARK: - Costs for all produced Products
        
    func productionCostExVAT(in period: Period) -> Double {
        productionQty(in: period) * cost(in: period)
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
}


extension Product: Productable {

    //  MARK: - Qty
    
    func salesQty(in period: Period) -> Double {
        sales.reduce(0) { $0 + $1.salesQty(in: period) }
    }
    
    func productionQty(in period: Period) -> Double {
        productionQty / self.period.hours * period.hours
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
}

