//
//  MassVolumeUnit.swift
//  Factory Model
//
//  Created by Igor Malyarov on 02.08.2020.
//

import Foundation

//  MARK: - change to array?? Array<Dimention>
enum MassVolumeUnit: String, CaseIterable {
    case gram = "грамм"
    case kilo = "кило"
    case liter = "литр"
    
    var unit: Dimension {
        switch self {
            case .gram:  return Dimension(symbol: "g")//UnitMass.grams
            case .kilo:  return Dimension(symbol: "kg")//UnitMass.kilograms
            case .liter: return Dimension(symbol: "L")//UnitVolume.liters
        }
    }
}
