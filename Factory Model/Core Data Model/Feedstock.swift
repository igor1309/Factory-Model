//
//  Feedstock.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation
import CoreData

extension Feedstock {
    var unitKinda: Unit? {
        get { unitSymbol_ == nil ? nil : Unit(symbol: unitSymbol_!) }
        set { unitSymbol_ = newValue?.symbol }
    }
        
//    var allIngredients: Measurement<Dimension>? {
//        if let unit = unit {
//        let measures = ingredients
//            .compactMap { $0.measure }
//            .reduce(0) { $0 + $1.converted(to: unit).value }
//        }
//        return nil
//    }
    
    
    var priceWithVAT: Double {
        get { priceExVAT * (1 + vat) }
        set { priceExVAT = vat == 0 ? 0 : newValue / vat }
    }
    var ingredients: [Ingredient] {
        get { (ingredients_ as? Set<Ingredient> ?? []).sorted() }
        set { ingredients_ = Set(newValue) as NSSet }
    }

    var productionQty: Double {
        ingredients
            .map { $0.qty * ($0.base?.productionQty ?? 0) }
            .reduce(0, +)
    }

    var totalCostExVat: Double { priceExVAT * productionQty }
    var totalCostWithVat: Double { priceWithVAT * productionQty }
}

extension Feedstock: Comparable {
    public static func < (lhs: Feedstock, rhs: Feedstock) -> Bool {
        lhs.name < rhs.name
    }
}
