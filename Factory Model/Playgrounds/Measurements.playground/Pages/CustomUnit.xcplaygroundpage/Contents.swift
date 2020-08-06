//: [Previous](@previous)

import Foundation

enum CustomUnit: String, CustomStringConvertible {
    case piece = "штук"
    case gram = "грамм"
    case kilogram = "кило"
    case tonn = "тонн"
    case liter = "литр"
    
    var description: String {
        "unit: \(self.rawValue)"
    }
    
    func availableCasesFor() -> [CustomUnit] {
        switch self {
            case .piece:
                return [.piece]
            case .gram, .kilogram, .tonn:
                return [.gram, .kilogram, .tonn]
            case .liter:
                return [.liter]
        }
    }
    
    func coefficient(to: CustomUnit) -> Double? {
        switch (self, to) {
            case (.piece, .piece),
                 (.gram, .gram),
                 (.kilogram, .kilogram),
                 (.tonn, .tonn),
                 (.liter, .liter):
                return 1
            case (.gram, .kilogram),
                 (.kilogram, .tonn):
                return 1/1_000
            case (.kilogram, .gram),
                 (.tonn, .kilogram):
                return 1_000
            case (.gram, .tonn):
                return 1/1_000/1_000
            case (.tonn, .gram):
                return 1_000 * 1_000
            default:
                return nil
        }
    }
}

let gram = CustomUnit.gram
print(gram.availableCasesFor())
print(gram.coefficient(to: .kilogram) ?? "not convertible")
print(gram.coefficient(to: .tonn) ?? "not convertible")
print(gram.coefficient(to: .liter) ?? "not convertible")

//: [Next](@next)
