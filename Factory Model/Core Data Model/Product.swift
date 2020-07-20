//
//  Product.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Product {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var note: String {
        get { note_ ?? "Unknown"}
        set { note_ = newValue }
    }
    var code: String {
        get { code_ ?? "Unknown"}
        set { code_ = newValue }
    }
    var group: String {
        get { group_ ?? "Unknown"}
        set { group_ = newValue }
    }
    var feedstock: Set<Feedstock> {
        get { feedstock_ as? Set<Feedstock> ?? [] }
        set { feedstock_ = newValue as NSSet }
    }
    var sales: Set<Sales> {
        get { sales_ as? Set<Sales> ?? [] }
        set { sales_ = newValue as NSSet }
    }
    var utilities: Set<Utility> {
        get { utilities_ as? Set<Utility> ?? [] }
        set { utilities_ = newValue as NSSet }
    }
}

extension Product: Comparable {
    public static func < (lhs: Product, rhs: Product) -> Bool {
        lhs.code < rhs.code
    }
    
    
}
