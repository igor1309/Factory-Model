//
//  File.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.09.2020.
//

import Foundation

// Makable - Base & Product

struct Make {
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

protocol Makable {
    func made(in period: Period) -> Make
}

extension Makable {
    func made(in period: Period) -> Make {
        //  MARK: - FINISH THIS
        Make(
            productionQty: 0,
            salesQty: 0,
            perUnit: PriceCostMargin(
                price: 0,
                cost: 0
            )
        )
    }
}

extension Base: Makable {
    
    func made(in period: Period) -> Make {
        
        /// умножить количество первичного продукта в упаковке (baseQty) на производимое количество (productionQty)
        let productionQty = products.reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.made(in: period).productionQty }
        
        let salesQty = products.reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.made(in: period).salesQty }
        
        return Make(
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

extension Product: Makable {
    
    func made(in period: Period) -> Make {
        
        let productionQty = sales.reduce(0) { $0 + $1.salesQty(in: period) }
        
        let salesQty = productionQty / self.period.hours * period.hours
        
        return Make(
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
