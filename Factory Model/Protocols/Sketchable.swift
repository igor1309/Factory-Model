//
//  Samplable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import CoreData

protocol Sketchable where Self: NSManagedObject {
    func makeSketch()
}

extension Sketchable where Self: Monikerable {
    func makeSketch() {
        name = ""
    }
}

extension Base: Sketchable {}
extension Buyer: Sketchable {}
extension Department: Sketchable {}
extension Division: Sketchable {}

extension Equipment: Sketchable {
    func makeSketch() {
        name = " ..."
        lifetime = 7
        price = 1_000_000
    }
}

extension Expenses: Sketchable {
    func makeSketch() {
        name = " ..."
        note = "..."
        amount = 10_000
    }
}

extension Ingredient: Sketchable {
    func makeSketch() {
        name = " ..."
        priceExVAT = 70
        vat = 10/100
    }
}

extension Recipe: Sketchable {}
extension Factory: Sketchable {}
extension Packaging: Sketchable {}

extension Product: Sketchable {
    func makeSketch() {
        name = " ..."
        vat = 10/100
    }
}

extension Sales: Sketchable {}

extension Utility: Sketchable {
    func makeSketch() {
        name = " ..."
        priceExVAT = 10
    }
}

extension Employee: Sketchable {}
