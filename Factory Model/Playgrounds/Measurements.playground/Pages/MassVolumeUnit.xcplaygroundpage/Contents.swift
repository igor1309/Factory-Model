import Foundation

class Recipe {
    var qty: Double
    var unit: Dimension
    
    init(qty: Double, unit: Dimension) {
        self.qty = qty
        self.unit = unit
    }
    
    var measure: Measurement<Dimension> {
        Measurement(value: qty, unit: unit)
    }
}

class Ingredient {
    var unit: Dimension
    var recipes_: [Recipe]
    
    init(unit: Dimension) {
        self.unit = unit
        self.recipes_ = []
    }
    
    var measure: Measurement<Dimension> {
        recipes_
            .reduce(Measurement(value: 0, unit: unit)) {
                $0 + $1.measure.converted(to: unit)
            }
    }
}

let recipe1 = Recipe(qty: 10_000, unit: UnitMass.kilograms)
print(recipe1.measure)
//let recipe2 = Recipe(qty: 1_000, unit: UnitMass.grams)
let ingredient1 = Ingredient(unit: UnitMass.metricTons)
ingredient1.recipes_.append(recipe1)
//ingredient1.recipes_.append(recipe2)
print(ingredient1.measure)
let recipe3 = Recipe(qty: 100, unit: UnitVolume.liters)
ingredient1.recipes_.append(recipe3)
print(ingredient1.measure)
print(recipe1.measure.converted(to: UnitVolume.liters))
print(recipe3.measure.converted(to: UnitMass.grams))

//----------------------------------------------------------------------------------

//  https://stackoverflow.com/a/61547403/11793043
protocol Valued {
    var value: Double { get }
}

extension Measurement: Valued { }
extension Collection where Element: Valued {
    func test() {
        print(self)
    }
    // note that it is pointless to sum different types of units
    var sum: Double {
        reduce(0) { $0 + $1.value }
    }
    // you would need to cast every element to the appropriate unit type before calculating its sum
    var totalLengthInMeters: Double {
        reduce(0) {
            $0 + (($1 as? Measurement<UnitLength>)?.converted(to: .meters).value ?? 0)
        }
    }
}
let measurement1: Measurement<Dimension> = Measurement(value: 10, unit: UnitLength.decimeters)
let measurement2: Measurement<Dimension> = Measurement(value: 11, unit: UnitLength.centimeters)
let measurement3: Measurement<Dimension> = Measurement(value: 100, unit: UnitMass.kilograms)
let array: [Measurement<Dimension>] = [measurement1, measurement2, measurement3]
let measurement1UnitLength = measurement1 //as? Measurement<UnitLength>
print(array.totalLengthInMeters)
//----------------------------------------------------------------------------------




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
