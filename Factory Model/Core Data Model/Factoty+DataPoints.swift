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
        let title = title ?? "Weight Netto, t"
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
        let title = title ?? "Weight Netto, t"
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
        let title = title ?? "Revenue"
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
        let title = title ?? "Base Products Revenue"
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
    
    
    //  Output (production) Cost Structure Data Points
    
    func productionIngredientCostExVATDataPoints(in period: Period) -> DataBlock {
        let ingredients = productionCost(in: period).ingredientCostExVAT
        let data = bases.map {
            DataPointWithShare(
                title:      $0.name,
                value:      $0.productionCost(in: period).ingredientCostExVATStr,
                percentage: $0.productionCost(in: period).ingredientCostExVATPercentageStr
            )
        }
        
        return DataBlock(icon: Ingredient.icon, title: "Ingredients", value: ingredients.formattedGrouped, data: data)
    }
    
    func productionSalaryWithTaxDataPoints(in period: Period) -> DataBlock {
        let salary = productionSalaryWithTax(in: period)
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.productionSalaryWithTax(in: period).formattedGrouped,
                percentage: (salary == 0 ? 0 : $0.productionSalaryWithTax(in: period) / salary).formattedPercentage
            )
        }
        
        return DataBlock(icon: Employee.icon, title: "Salary", value: salary.formattedGrouped, data: data)
    }
    
    func depreciationDataPoints(in period: Period) -> DataBlock {
        let depreciation = unitCost(in: period).depreciation// depreciationMonthly//depreciationWithTax(in: period)
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.depreciationWithTax(in: period).formattedGrouped,
                percentage: (depreciation == 0 ? 0 : $0.depreciationWithTax(in: period) / depreciation).formattedPercentage
            )
        }
        
        return DataBlock(icon: Equipment.icon, title: "Depreciation", value: depreciation.formattedGrouped, data: data)
    }
    
    func utilitiesExVATDataPoints(in period: Period) -> DataBlock {
        let utilities = unitCost(in: period).utilityCostExVAT
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.utilitiesExVAT(in: period).formattedGrouped,
                percentage: (utilities == 0 ? 0 : $0.utilitiesExVAT(in: period) / utilities).formattedPercentage
            )
        }
        
        return DataBlock(icon: Utility.icon, title: "Utility", value: utilities.formattedGrouped, data: data)
    }
    
    
    //  Output (production) Cost Structure Percentage Data Points
    
    func productionCostStructureDataPoints(in period: Period) -> DataBlock {
        let ingredients = productionCost(in: period).ingredientCostExVATPercentage
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.ingredientsExVATPercentageStr(in: period)
            )
        }
        
        return DataBlock(icon: Ingredient.icon, title: "Ingredients", value: ingredients.formattedPercentageWith1Decimal, data: data)
    }
    
    func productionIngredientCostExVATPercentageDataPoints(in period: Period) -> DataBlock {
        let ingredients = productionCost(in: period).ingredientCostExVATPercentage
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.ingredientsExVATPercentageStr(in: period)
            )
        }
        
        return DataBlock(icon: Ingredient.icon, title: "Ingredients", value: ingredients.formattedPercentageWith1Decimal, data: data)
    }
    
    func productionSalaryWithTaxPercentageDataPoints(in period: Period) -> DataBlock {
        let salary = salaryWithTaxPercentage(in: period) ?? 0
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.salaryWithTaxPercentageStr(in: period)
            )
        }
        
        return DataBlock(icon: Employee.icon, title: "Salary", value: salary.formattedPercentageWith1Decimal, data: data)
    }
    
    func depreciationPercentageDataPoints(in period: Period) -> DataBlock {
        let depreciation = unitCost(in: period).depreciationPercentage
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.depreciationWithTaxPercentageStr(in: period)
            )
        }
        
        return DataBlock(icon: Equipment.icon, title: "Depreciation", value: depreciation.formattedPercentageWith1Decimal, data: data)
    }
    
    func utilitiesExVATPercentageDataPoints(in period: Period) -> DataBlock {
        let utilities = unitCost(in: period).utilityCostExVATPercentage
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.utilitiesExVATPercentageStr(in: period)
            )
        }
        
        return DataBlock(icon: Utility.icon, title: "Utility", value: utilities.formattedPercentageWith1Decimal, data: data)
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
