//
//  PCM.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.09.2020.
//

import Foundation

//  AveragePerKilo
//  avgPricePerKiloExVAT
//  avgCostPerKiloExVAT
//  avgMarginPerKiloExVAT

struct PCM {
    let price: Double
    let cost: Double
    
    var formatWithDecimal: Bool = false
    
    var margin: Double {
        price - cost
    }
    var marginPercentage: Double {
        price == 0 ? 0 : margin / price
    }
    
    var priceStr: String {
        if formatWithDecimal {
            return price.formattedGroupedWith1Decimal
        } else {
            return price.formattedGrouped
        }
    }
    var costStr: String {
        if formatWithDecimal {
            return cost.formattedGroupedWith1Decimal
        } else {
            return cost.formattedGrouped
        }
    }
    var marginStr: String {
        if formatWithDecimal {
            return margin.formattedGroupedWith1Decimal
        } else {
            return margin.formattedGrouped
        }
    }
    var marginPercentageStr: String {
        marginPercentage.formattedPercentageWith1Decimal
    }
}

