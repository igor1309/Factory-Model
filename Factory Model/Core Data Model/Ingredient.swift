//
//  Ingredient.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation
import CoreData

extension Ingredient {
    var unitKinda: Unit? {
        get { unitSymbol_ == nil ? nil : Unit(symbol: unitSymbol_!) }
        set { unitSymbol_ = newValue?.symbol }
    }
        
//    var allRecipes: Measurement<Dimension>? {
//        if let unit = unit {
//        let measures = recipes
//            .compactMap { $0.measure }
//            .reduce(0) { $0 + $1.converted(to: unit).value }
//        }
//        return nil
//    }
    
    
    var priceWithVAT: Double {
        get { priceExVAT * (1 + vat) }
        set { priceExVAT = vat == 0 ? 0 : newValue / vat }
    }
    var recipes: [Recipe] {
        get { (recipes_ as? Set<Recipe> ?? []).sorted() }
        set { recipes_ = Set(newValue) as NSSet }
    }

    var productionQty: Double {
        recipes
            .map { $0.qty * ($0.base?.productionQty ?? 0) }
            .reduce(0, +)
    }

    var totalCostExVat: Double { priceExVAT * productionQty }
    var totalCostWithVat: Double { priceWithVAT * productionQty }
}

extension Ingredient: Comparable {
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.name < rhs.name
    }
}
