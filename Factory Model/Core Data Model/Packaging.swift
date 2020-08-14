//
//  Packaging.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.07.2020.
//

import Foundation

extension Packaging: Comparable {
    var type: String {
        get { type_ ?? ""}
        set { type_ = newValue }
    }
    var products: [Product] {
        get { (products_ as? Set<Product> ?? []).sorted() }
        set { products_ = Set(newValue) as NSSet }
    }

    var productList: String {
        if products_ == nil || products.isEmpty {
            return "ERROR: not used in products"
        }
        return products.map(\.title).joined(separator: "\n")
    }
    
    public static func < (lhs: Packaging, rhs: Packaging) -> Bool {
        lhs.name < rhs.name
    }
}
