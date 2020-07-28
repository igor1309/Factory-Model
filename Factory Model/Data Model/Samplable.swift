//
//  Samplable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import CoreData

protocol Samplable {
    func makeSample()
}

extension Base: Samplable {
    func makeSample() {
        self.name = " ..."
    }
}

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
