//
//  MassVolumeUnit.swift
//  Factory Model
//
//  Created by Igor Malyarov on 02.08.2020.
//

import Foundation

class UnitPiece: Unit {
    static let piece = UnitPiece(symbol: "pc")
//    static let piece = UnitPiece(symbol: "pc", converter: UnitConverterLinear(coefficient: 1.0))

    static let baseUnit = piece

}

enum MyUnit {
    case piece(UnitPiece)
    case gram(UnitMass)
    case kilo(UnitMass)
    case liter(UnitVolume)
    
//    case piece = "штука"
//    case gram = "грамм"
//    case kilo = "кило"
//    case liter = "литр"
    
    var unit: Unit {
        switch self {
            case .piece: return UnitPiece.piece
            case .gram:  return UnitMass.grams
            case .kilo:  return UnitMass.kilograms
            case .liter: return UnitVolume.liters
        }
    }
}
