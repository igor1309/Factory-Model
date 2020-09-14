//
//  Factoty+DataPoints.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import Foundation

extension Factory {
    
    //  MARK: - Data Points
    
    var products: [Product] {
        bases.flatMap(\.products)
    }
    
    //  Weight Netto
        
    func salesWeightNettoDataPoints(in period: Period) -> DataBlock {
        let weight = salesWeightNetto(in: period)
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.salesWeightNetto(in: period).formattedGroupedWith1Decimal,
                percentage: (weight == 0 ? 0 : $0.salesWeightNetto(in: period) / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "scalemass", title: "Weight Netto, t", value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    func productionWeightNettoDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let weight = productionWeightNetto(in: period)
        let title = title == nil ? "Weight Netto, t" : title!
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.productionWeightNetto(in: period).formattedGroupedWith1Decimal,
                percentage: (weight == 0 ? 0 : $0.productionWeightNetto(in: period) / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "scalemass", title: title, value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    func basesProductionWeightNettoDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let weight = productionWeightNetto(in: period)
        let title = title == nil ? "Weight Netto, t" : title!
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.productionWeightNetto(in: period).formattedGroupedWith1Decimal,
                percentage: (weight == 0 ? 0 : $0.productionWeightNetto(in: period) / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "scalemass", title: title, value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    
    //  Revenue
    
    func revenueDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let revenue = revenueExVAT(in: period)
        let title = title == nil ? "Revenue" : title!
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.revenueExVAT(in: period).formattedGrouped,
                percentage: (revenue == 0 ? 0 : $0.revenueExVAT(in: period) / revenue).formattedPercentage
            )
        }
        
        return DataBlock(icon: "creditcard", title: title, value: revenue.formattedGrouped, data: data)
    }
    
    func basesRevenueDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let revenue = revenueExVAT(in: period)
        let title = title == nil ? "Base Products Revenue" : title!
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.revenueExVAT(in: period).formattedGrouped,
                percentage: (revenue == 0 ? 0 : $0.revenueExVAT(in: period) / revenue).formattedPercentage
            )
        }
        
        return DataBlock(icon: "creditcard", title: title, value: revenue.formattedGrouped, data: data)
    }
    
    
    //  Avg Price and Cost per Kilo
    
    func avgPricePerKiloExVATDataPoints(in period: Period) -> DataBlock {
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
    
    func avgCostPerKiloExVATDataPoints(in period: Period) -> DataBlock {
        let cost = avgCostPerKiloExVAT(in: period)
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.avgCostPerKiloExVAT(in: period).formattedGrouped,
                percentage: (cost == 0 ? 0 : $0.avgCostPerKiloExVAT(in: period) / cost).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Avg Cost per kilo", value: cost.formattedGrouped, data: data)
    }
    
    func ingredientCostExVATDataPoints(in period: Period) -> DataBlock {
        let ingredients = ingredientCostExVATPercentage(in: period) ?? 0
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.ingredientsExVATPercentageStr(in: period),
                percentage: ""
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Ingredients", value: ingredients.formattedPercentageWith1Decimal, data: data)
    }
    
    func salaryWithTaxDataPoints(in period: Period) -> DataBlock {
        let salary = salaryWithTaxPercentage(in: period) ?? 0
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.salaryWithTaxPercentageStr(in: period),
                percentage: ""
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Salary", value: salary.formattedPercentageWith1Decimal, data: data)
    }
    
    func depreciationWithTaxDataPoints(in period: Period) -> DataBlock {
        let depreciation = depreciationMonthlyPercentage(in: period) ?? 0
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.depreciationWithTaxPercentageStr(in: period),
                percentage: ""
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Depreciation", value: depreciation.formattedPercentageWith1Decimal, data: data)
    }
    
    func utilitiesExVATDataPoints(in period: Period) -> DataBlock {
        let utilities = utilitiesExVATPercentage(in: period) ?? 0
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.utilitiesExVATPercentageStr(in: period),
                percentage: ""
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Utility", value: utilities.formattedPercentageWith1Decimal, data: data)
    }
    

    //  Margin
    
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
