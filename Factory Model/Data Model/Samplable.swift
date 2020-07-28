//
//  Samplable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import CoreData

protocol Samplable where Self: NSManagedObject {
    func makeSample()
}

extension Samplable where Self: Monikerable {
    func makeSample() {
        name = "..."
    }
}

extension Base: Samplable {
    func makeSample() {
        self.name = " ..."
    }
}

extension Buyer: Samplable {}
    
extension Equipment: Samplable {
    func makeSample() {
        self.name = " ..."
        self.lifetime = 7
        self.price = 1_000_000
    }
}

extension Expenses: Samplable {
    func makeSample() {
        self.name = " ..."
        self.note = "..."
        self.amount = 10_000
    }
}

extension Feedstock: Samplable {
    func makeSample() {
        self.name = " ..."
        self.priceExVAT = 70
        self.vat = 10/100
    }
}

extension Ingredient: Samplable {}
extension Factory: Samplable {}
extension Packaging: Samplable {}

extension Product: Samplable {
    func makeSample() {
        self.name = " ..."
        self.vat = 10/100
    }
}
