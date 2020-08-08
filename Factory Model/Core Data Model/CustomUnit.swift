//
//  CustomUnit.swift
//  Factory Model
//
//  Created by Igor Malyarov on 07.08.2020.
//

import Foundation

enum CustomUnit: String, CaseIterable, CustomStringConvertible {
    case piece = "штук"
    case gram = "грамм"
    case kilogram = "кило"
    case tonn = "тонн"
    case liter = "литр"
    
    var description: String {
        "unit: \(self.rawValue)"
    }
    
    var availableCasesFor: [CustomUnit] {
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
    
    static func unit(from baseUnit: CustomUnit, with coefficient: Double) -> CustomUnit {
        switch (baseUnit, coefficient) {
            case (.piece, _): return .piece
            case (.liter, _): return .liter
            case (.gram, let coefficient):
                switch coefficient {
                    case 1_000: return .kilogram
                    case 1_000_000: return .tonn
                    default: return .gram
                }
            case (.kilogram, let coefficient):
                switch coefficient {
                    case 1/1_000: return .gram
                    case 1_000: return .tonn
                    default: return .kilogram
                }
            case (.tonn, let coefficient):
                switch coefficient {
                    case 1/1_000/1_000: return .gram
                    case 1/1_000: return .kilogram
                    default: return .tonn
                }
        }
    }
}
