//
//  MassVolumeUnit.swift
//  Factory Model
//
//  Created by Igor Malyarov on 02.08.2020.
//

import Foundation

enum MassVolumeUnit: String, CaseIterable {
    case gram = "грамм"
    case kilo = "кило"
    case liter = "литр"
    
    var unit: Unit {
        switch self {
            case .gram:  return Unit(symbol: "g")//UnitMass.grams
            case .kilo:  return Unit(symbol: "kg")//UnitMass.kilograms
            case .liter: return Unit(symbol: "L")//UnitVolume.liters
        }
    }
}
