//
//  Buyer.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import Foundation

extension Buyer: Comparable {
    var sales: [Sales] {
        get { (sales_ as? Set<Sales> ?? []).sorted() }
        set { sales_ = Set(newValue) as NSSet }
    }

    public static func < (lhs: Buyer, rhs: Buyer) -> Bool {
        lhs.name < rhs.name
    }
}
