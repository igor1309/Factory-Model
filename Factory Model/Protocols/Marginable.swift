//
//  Marginable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import Foundation

protocol Marginable: Productable {
    //  MARK: - Margin
    // NOT REALLY MARGIN???
    func margin(in period: Period) -> Double
    func totalMargin(in period: Period) -> Double
    func marginPercentage(in period: Period) -> Double
}

extension Marginable {
    //  MARK: - Margin
    // NOT REALLY MARGIN???
    func margin(in period: Period) -> Double {
        avgPriceExVAT(in: period) - cost(in: period)
    }
    
    func totalMargin(in period: Period) -> Double {
        revenueExVAT(in: period) - cogs(in: period)
    }
    
    func marginPercentage(in period: Period) -> Double {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? (1 - cogs(in: period) / revenue) : 0
    }
    
    
}

extension Base: Marginable{}
extension Product: Marginable{}
