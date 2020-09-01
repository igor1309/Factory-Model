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
        
    func salesWeightNettoDataPoints(in period: Period) -> DataBlock {
        let weight = salesWeightNetto(in: period)
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.salesWeightNetto(in: period).formattedGroupedWith1Decimal,
                percentage: (weight == 0 ? 0 : $0.salesWeightNetto(in: period) / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Weight Netto, t", value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    func productionWeightNettoDataPoints(in period: Period) -> DataBlock {
        let weight = productionWeightNetto(in: period)
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.productionWeightNetto(in: period).formattedGroupedWith1Decimal,
                percentage: (weight == 0 ? 0 : $0.productionWeightNetto(in: period) / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Weight Netto, t", value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    func revenueDataPoints(in period: Period) -> DataBlock {
        let revenue = revenueExVAT(in: period)
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.revenueExVAT(in: period).formattedGrouped,
                percentage: (revenue == 0 ? 0 : $0.revenueExVAT(in: period) / revenue).formattedPercentage
            )
        }
        
        return DataBlock(icon: "creditcard", title: "Revenue", value: revenue.formattedGrouped, data: data)
    }
    
    func avgPricePerKiloExVATDataPointWithShare(in period: Period) -> DataBlock {
        let price = avgPricePerKiloExVAT(in: period)
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.avgPricePerKiloExVAT(in: period).formattedGrouped,
                percentage: (price == 0 ? 0 : $0.avgPricePerKiloExVAT(in: period) / price).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Avg Price per kilo", value: price.formattedGrouped, data: data)
    }
    
    func avgCostPerKiloExVATDataPointWithShare(in period: Period) -> DataBlock {
        let price = avgCostPerKiloExVAT(in: period)
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.avgCostPerKiloExVAT(in: period).formattedGrouped,
                percentage: (price == 0 ? 0 : $0.avgCostPerKiloExVAT(in: period) / price).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Avg Cost per kilo", value: price.formattedGrouped, data: data)
    }
    
    func marginDataPoints(in period: Period) -> DataBlock {
        let totalMargin = margin(in: period)
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.totalMargin(in: period).formattedGrouped,
                percentage: (totalMargin == 0 ? 0 : $0.totalMargin(in: period) / totalMargin).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Margin", value: totalMargin.formattedGrouped, data: data)
    }
    
    func marginPercentageDataPointWithShare(in period: Period) -> DataBlock {
        let margin = marginPercentage(in: period) ?? 0
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.marginPercentage(in: period).formattedPercentage,
                percentage: (margin == 0 ? 0 : $0.marginPercentage(in: period) / margin).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Margin %%", value: margin.formattedPercentage, data: data)

    }
}
