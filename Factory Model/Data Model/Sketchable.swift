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
        self.name = " ..."
        self.lifetime = 7
        self.price = 1_000_000
    }
}

extension Expenses: Sketchable {
    func makeSketch() {
        self.name = " ..."
        self.note = "..."
        self.amount = 10_000
    }
}

extension Ingredient: Sketchable {
    func makeSketch() {
        self.name = " ..."
        self.priceExVAT = 70
        self.vat = 10/100
    }
}

extension Recipe: Sketchable {}
extension Factory: Sketchable {}
extension Packaging: Sketchable {}

extension Product: Sketchable {
    func makeSketch() {
        self.name = " ..."
        self.vat = 10/100
    }
}

extension Sales: Sketchable {}

extension Utility: Sketchable {
    func makeSketch() {
        self.name = " ..."
        priceExVAT = 10
    }
}

extension Employee: Sketchable {}
