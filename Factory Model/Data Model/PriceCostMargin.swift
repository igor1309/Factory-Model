//
//  PriceCostMargin.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.09.2020.
//

import Foundation

//  AveragePerKilo
//  avgPricePerKiloExVAT
//  avgCostPerKiloExVAT
//  avgMarginPerKiloExVAT

struct PriceCostMargin {
    let price: Double
    let cost: Double
    
    var margin: Double {
        price - cost
    }
    var marginPercentage: Double {
        price == 0 ? 0 : margin / price
    }
    
    var priceStr: String {
        price.formattedGroupedWith1Decimal
    }
    var costStr: String {
        cost.formattedGroupedWith1Decimal
    }
    var marginStr: String {
        margin.formattedGroupedWith1Decimal
    }
    var marginPercentageStr: String {
        marginPercentage.formattedPercentageWith1Decimal
    }
}

