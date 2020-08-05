import Foundation

class UnitPiece: Dimension {
    static let piece = UnitPiece(symbol: "pc")
    //    static let piece = UnitPiece(symbol: "pc", converter: UnitConverterLinear(coefficient: 1.0))
    
    static let baseUnit = piece
    
}

enum MyUnit: String, CaseIterable {
    //    case piece = UnitPiece.self
    //    case gram = UnitMass.self
    //    case kilo = UnitMass.self
    //    case liter = UnitVolume.self
    
    case piece = "штука"
    case gram = "грамм"
    case kilo = "кило"
    case liter = "литр"
    
    var type: Dimension.Type {
        switch self {
            case .piece: return UnitPiece.self
            case .gram:  return UnitMass.self
            case .kilo:  return UnitMass.self
            case .liter: return UnitVolume.self
        }
    }
    
    var unit: Unit {
        switch self {
            case .piece: return UnitPiece.piece
            case .gram:  return UnitMass.grams
            case .kilo:  return UnitMass.kilograms
            case .liter: return UnitVolume.liters
        }
    }
}

//let myUnit1 = MyUnit.gram(UnitMass.grams)
let myUnit2 = MyUnit.gram
let type2 = myUnit2.type
let mesure2 = Measurement(value: 10, unit: myUnit2.unit)
let what = myUnit2.unit
print(myUnit2.unit.symbol)

let dimensionTypes: [Dimension.Type] = [UnitMass.self, UnitVolume.self]
