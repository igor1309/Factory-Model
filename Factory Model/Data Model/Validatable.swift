//
//  Validatable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

protocol Validatable {
    var isValid: Bool { get }
}
extension Validatable where Self: Summarable {
    var isValid: Bool {
        let hasError = self.detail?.hasPrefix("ERROR") ?? true
        return !hasError
    }
}

extension Base: Validatable {}
extension Feedstock: Validatable {}
extension Packaging: Validatable {}
extension Product: Validatable {}
