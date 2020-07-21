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
    var feedstock: [Feedstock] {
        get { (feedstock_ as? Set<Feedstock> ?? []).sorted() }
        set { feedstock_ = Set(newValue) as NSSet }
    }
    var sales: [Sales] {
        get { (sales_ as? Set<Sales> ?? []).sorted() }
        set { sales_ = Set(newValue) as NSSet }
    }
    var utilities: [Utility] {
        get { (utilities_ as? Set<Utility> ?? []).sorted() }
        set { utilities_ = Set(newValue) as NSSet }
    }
}

extension Product: Comparable {
    public static func < (lhs: Product, rhs: Product) -> Bool {
        lhs.code < rhs.code
    }
    
    
}
