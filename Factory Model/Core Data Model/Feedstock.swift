//
//  Feedstock.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation
import CoreData

extension Feedstock {
    var unit: Unit? {
        get { unit_ == nil ? nil : Unit(symbol: unit_!) }
        set { unit_ = newValue?.symbol }
    }
    
//    var unitString: String {
//        get { unit_ ?? "not set" }
//        set { unit_ = newValue }
//    }
//    var unit: MassVolumeUnit {
//        get {
////            print("unit: MassVolumeUnit: get")
//            return MassVolumeUnit(rawValue: unit_ ?? MassVolumeUnit.gramm.rawValue) ?? .gramm
//        }
//        set { print("unit: MassVolumeUnit: set")
//            unit_ = newValue.rawValue }
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
