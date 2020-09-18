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
        let weight = sold(in: period).weightNetto
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.sold(in: period).weightNettoStr,
                percentage: (weight == 0 ? 0 : $0.sold(in: period).weightNetto / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "scalemass", title: "Weight Netto, t", value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    func productionWeightNettoDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let weight = produced(in: period).weightNetto
        let title = title ?? "Weight Netto, t"
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.produced(in: period).weightNettoStr,
                percentage: (weight == 0 ? 0 : $0.produced(in: period).weightNetto / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "scalemass", title: title, value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    func basesProductionWeightNettoDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let weight = produced(in: period).weightNetto
        let title = title ?? "Weight Netto, t"
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.produced(in: period).weightNettoStr,
                percentage: (weight == 0 ? 0 : $0.produced(in: period).weightNetto / weight).formattedPercentage
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
        //avgPricePerKiloExVAT(in: period)
        let price = sold(in: period).perKilo.price
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                //value: $0.avgPricePerKiloExVAT(in: period).formattedGrouped,
                //value: $0.avgPerKiloExVAT(in: period).priceStr,
                value: $0.sold(in: period).perKilo.priceStr,
                //percentage: (price == 0 ? 0 : $0.avgPricePerKiloExVAT(in: period) / price).formattedPercentage
                percentage: (price == 0 ? 0 : $0.sold(in: period).perKilo.price / price).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Avg Price per kilo", value: price.formattedGrouped, data: data)
    }
    
    func avgCostPerKiloExVATDataPoints(in period: Period) -> DataBlock {
        //  avgCostPerKiloExVAT(in: period)
        let cost = sold(in: period).perKilo.cost
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                //value: $0.avgCostPerKiloExVAT(in: period).formattedGrouped,
                //value: $0.avgPerKiloExVAT(in: period).costStr,
                value: $0.sold(in: period).perKilo.costStr,
                //percentage: (cost == 0 ? 0 : $0.avgCostPerKiloExVAT(in: period) / cost).formattedPercentage
                percentage: (cost == 0 ? 0 : $0.sold(in: period).perKilo.cost / cost).formattedPercentage
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
                percentage: $0.productionCost(in: period).ingredientCostExVATPercentageStr
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
                percentage: $0.productionCost(in: period).ingredientCostExVATPercentageStr
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
                percentage: $0.productionCost(in: period).salaryWithTaxPercentageStr
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
                percentage: $0.unitCost(in: period).depreciationPercentageStr
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
                percentage: $0.unitCost(in: period).utilityCostExVATPercentageStr
            )
        }
        
        return DataBlock(icon: Utility.icon, title: "Utility", value: utilities.formattedPercentageWith1Decimal, data: data)
    }
    

    //  Margin
    
    func marginDataPoints(in period: Period) -> DataBlock {
        let totalMargin = pnl(in: period).margin
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                //value: $0.totalMargin(in: period).formattedGrouped,
                value: $0.sold(in: period).total.marginStr,
                //percentage: (totalMargin == 0 ? 0 : $0.totalMargin(in: period) / totalMargin).formattedPercentage
                percentage: $0.sold(in: period).total.marginPercentageStr
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Margin", value: totalMargin.formattedGrouped, data: data)
    }
    
    func marginPercentageDataPointWithShare(in period: Period) -> DataBlock {
        let marginPercentage = sold(in: period).total.marginPercentage //pnl(in: period).marginPercentage ?? 0
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                //value: $0.marginPercentage(in: period).formattedPercentage,
                value: $0.sold(in: period).total.marginPercentageStr,
                //percentage: (marginPercentage == 0 ? 0 : $0.marginPercentage(in: period) / marginPercentage).formattedPercentage
                percentage: (marginPercentage == 0 ? 0 : $0.sold(in: period).total.marginPercentage / marginPercentage).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Margin %%", value: sold(in: period).total.marginPercentageStr, data: data)
    }
}
