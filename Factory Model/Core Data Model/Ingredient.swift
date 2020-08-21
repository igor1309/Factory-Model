//
//  Ingredient.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation
import CoreData

extension Ingredient {
    var customUnit: CustomUnit? {
        get { CustomUnit(rawValue: unitString_ ?? "") }
        set { unitString_ = newValue?.rawValue }
    }
    
    var priceWithVAT: Double {
        get { priceExVAT * (1 + vat) }
        set { priceExVAT = vat == 0 ? 0 : newValue / vat }
    }
    var recipes: [Recipe] {
        get { (recipes_ as? Set<Recipe> ?? []).sorted() }
        set { recipes_ = Set(newValue) as NSSet }
    }

    /// if Factory is nill sum for all factories
    func productionQty(for factory: Factory? = nil) -> Double {
        recipes
            .filter {
                if let factory = factory {
                    return $0.base?.factory == factory
                } else {
                    return true
                }
            }
            .reduce(0) { $0 + $1.productionQty }
    }

    func totalCostExVat(for factory: Factory? = nil) -> Double {
        priceExVAT * productionQty(for: factory)
    }
    func totalCostWithVat(for factory: Factory? = nil) -> Double {
        priceWithVAT * productionQty(for: factory)
    }
}

extension Ingredient: Comparable {
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.name < rhs.name
    }
}
