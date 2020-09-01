//
//  Factoty+DataPoints.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import Foundation

extension Factory {
    
    //  MARK: - Sales Analysis
    
    var products: [Product] {
        bases.flatMap(\.products)
    }
        
    func revenueDataPoints(in period: Period) -> [DataPoint] {
        products.map {
            DataPoint(
                title: $0.name,
                value: $0.revenueExVAT(in: period)
            )
        }
    }
    
    func marginDataPoints(in period: Period) -> [DataPoint] {
        products.map {
            DataPoint(
                title: $0.name,
                value: $0.totalMargin(in: period)// margin(in: period)
            )
        }
    }
    
    func salesWeightNettoDataPoints(in period: Period) -> [DataPoint] {
        products.map {
            DataPoint(
                title: $0.name,
                value: $0.salesWeightNetto(in: period) * 1_000
            )
        }
    }
    
    func avgPriceExVATDataPointWithShare(in period: Period) -> [DataPointWithShare] {
        let price = avgPricePerKiloExVAT(in: period)
        
        return products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.avgPriceExVAT(in: period),
                percentage: price == 0 ? 0 : $0.avgPriceExVAT(in: period) / price
            )
        }
    }
    
    func marginPercentageDataPointWithShare(in period: Period) -> [DataPointWithShare] {
        let margin = marginPercentage(in: period) ?? 0
        
        return products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.marginPercentage(in: period),
                percentage: margin == 0 ? 0 : $0.marginPercentage(in: period) / margin
            )
        }
    }
}
