//
//  Ingredient.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import Foundation

extension Ingredient: Comparable {

//    var measurement: Measurement<Unit> {
//        let mvUnit = MassVolumeUnit(rawValue: unit_ ?? MassVolumeUnit.kilo.rawValue) ?? .kilo
//        let unit = mvUnit.unit
//        return Measurement(value: qty, unit: unit)
//    }
    

    
    var cost: Double {
        qty * (feedstock?.priceExVAT ?? 0)
    }
    
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.qty < rhs.qty
    }
}
