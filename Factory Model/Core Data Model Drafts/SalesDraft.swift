//
//  SalesDraft.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import SwiftUI

struct SalesDraft: Identifiable {
    var priceExVAT: Double
    var qty: Double
    var period: Period
    var buyer: Buyer?
    var product: Product?
    
    var id = UUID()
}
