//
//  Feedstock.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation
import CoreData

extension Feedstock {
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
