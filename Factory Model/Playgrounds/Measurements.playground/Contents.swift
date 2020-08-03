import Foundation

enum MassVolumeUnit: String, CaseIterable {
    case gram, kilo, liter
    
    var ruValue: String {
        switch self {
            case .gram:  return "грамм"
            case .kilo:  return "кило"
            case .liter: return "литр"
        }
    }
    
    var unit: Unit {
        switch self {
            case .gram:  return UnitMass.grams
            case .kilo:  return UnitMass.kilograms
            case .liter: return UnitVolume.liters
        }
    }
}

final class Example {
    var qty: Double
    var unit_: String
    
    init(qty: Double, unit_: String) {
        self.qty = qty
        self.unit_ = unit_
    }
    
    var measurement: Measurement<Unit> {
        get {
            let unit = (MassVolumeUnit(rawValue: unit_) ?? .kilo).unit
            return Measurement(value: qty, unit: unit)
        }
        //  MARK: - setter is not working
//        set {
//            qty = newValue.value
//            unit_ = newValue.unit.symbol
//        }
    }
}

let sample1 = Measurement(value: 100, unit: UnitMass.grams)
let sample2 = Measurement(value: 2, unit: UnitMass.kilograms)
let sample3 = Measurement(value: 10, unit: UnitVolume.liters)

let s1 = Example(qty: 100, unit_: "gramm")
print(s1.measurement)
let s2 = Example(qty: 2, unit_: "kilo")
print(s2.measurement)
let s3 = Example(qty: 10, unit_: "liter")
print(s3.measurement)

//s1.measurement = sample1
//print(s1.measurement)
//s2.measurement = sample2
//print(s2.measurement)
//s3.measurement = sample3
//print(s3.measurement)

for i in [UnitMass.grams,
          UnitMass.kilograms,
          UnitVolume.liters] {
    print(i.symbol)
}

let u = Unit(symbol: "g")
print(u)
