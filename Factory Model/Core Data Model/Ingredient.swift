//
//  Ingredient.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import Foundation

extension Ingredient: Comparable {
    
    
//    var unit: Unit? {
//        get { unit_ == nil ? nil : Unit(symbol: unit_!) }
//        set { unit_ = newValue?.symbol }
//    }

//    var measure: Measurement<Dimension>? {
//        if let unit = unit {
//            return Measurement(value: qty * base.map { $0.products }.map { $.baseQty }, unit: unit)
//        }
//        return nil
//    }
    
    var cost: Double {
        qty * (feedstock?.priceExVAT ?? 0)
    }
    
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.qty < rhs.qty
    }
}
