//
//  Makable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.09.2020.
//

import Foundation

//  MARK: Base & Product

struct Good {
    /// Production Qty
    let productionQty: Double
    /// Sales Qty
    let salesQty: Double
    /// PriceCostMargin per Unit
    let perUnit: PriceCostMargin
    
    var productionQtyStr: String {
        productionQty.formattedGrouped
    }
    var salesQtyStr: String {
        salesQty.formattedGrouped
    }
}

protocol Goodable {
    func made(in period: Period) -> Good
}

extension Goodable {
    func made(in period: Period) -> Good {
        //  MARK: - FINISH THIS
        Good(
            productionQty: 0,
            salesQty: 0,
            perUnit: PriceCostMargin(
                price: 0,
                cost: 0
            )
        )
    }
}

extension Base: Goodable {
    
    func made(in period: Period) -> Good {
        
        /// умножить количество первичного продукта в упаковке (baseQty) на производимое количество (productionQty)
        let productionQty = products.reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.made(in: period).productionQty }
        
        let salesQty = products.reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.made(in: period).salesQty }
        
        return Good(
            productionQty: productionQty,
            salesQty: salesQty,
            //  MARK: - FINISH THIS
            perUnit: PriceCostMargin(
                price: 0,
                cost: 0
            )
        )
    }
}

extension Product: Goodable {
    
    func made(in period: Period) -> Good {
        
        let productionQty = sales.reduce(0) { $0 + $1.salesQty(in: period) }
        
        let salesQty = productionQty / self.period.hours * period.hours
        
        return Good(
            productionQty: productionQty,
            salesQty: salesQty,
            //  MARK: - FINISH THIS
            perUnit: PriceCostMargin(
                price: 0,
                cost: 0
            )
        )
    }
}
