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
    
    func baseListWithProductionWeightNetto(in period: Period) -> String {
        bases
            .filter {
                $0.produced(in: period).weightNetto > 0
            }
            .map {
                "\($0.name) (\($0.produced(in: period).weightNettoTonsStr)t)"
            }
            .joined(separator: ", ")
    }
    
    func productListWithProductionWeightNetto(in period: Period) -> String {
        products
            .filter {
                $0.produced(in: period).weightNetto > 0
            }
            .map {
                "\($0.name) (\($0.produced(in: period).weightNettoTonsStr)t)"
            }
            .joined(separator: ", ")
    }
    
    //  MARK: Weight Netto
    
    func salesWeightNettoDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let weight = sold(in: period).weightNettoTons
        let title = title ?? "Weight Netto, t"
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.sold(in: period).weightNettoTonsStr,
                percentage: (weight == 0 ? 0 : $0.sold(in: period).weightNettoTons / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "scalemass", title: title, value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    func productionWeightNettoDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let weight = produced(in: period).weightNettoTons
        let title = title ?? "Weight Netto, t"
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.produced(in: period).weightNettoTonsStr,
                percentage: (weight == 0 ? 0 : $0.produced(in: period).weightNettoTons / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "scalemass", title: title, value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    func basesProductionWeightNettoDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let weight = produced(in: period).weightNettoTons
        let title = title ?? "Weight Netto, t"
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.produced(in: period).weightNettoTonsStr,
                percentage: (weight == 0 ? 0 : $0.produced(in: period).weightNettoTons / weight).formattedPercentage
            )
        }
        
        return DataBlock(icon: "scalemass", title: title, value: weight.formattedGroupedWith1Decimal, data: data)
    }
    
    
    //  MARK: Revenue
    
    func revenueDataPoints(in period: Period, title: String? = nil) -> DataBlock {
        let revenue = revenueExVAT(in: period)
        let title = title ?? "Revenue"
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.sold(in: period).revenue.formattedGrouped,
                percentage: (revenue == 0 ? 0 : $0.sold(in: period).revenue / revenue).formattedPercentage
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
                value: $0.sold(in: period).revenue.formattedGrouped,
                percentage: (revenue == 0 ? 0 : $0.sold(in: period).revenue / revenue).formattedPercentage
            )
        }
        
        return DataBlock(icon: "creditcard", title: title, value: revenue.formattedGrouped, data: data)
    }
    
    
    //  MARK: Avg Price and Cost per Kilo
    
    func avgPricePerKiloExVATDataPoints(in period: Period) -> DataBlock {
        //avgPricePerKiloExVAT(in: period)
        let price = perKilo(in: period).price
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                //value: $0.avgPricePerKiloExVAT(in: period).formattedGrouped,
                //value: $0.avgPerKiloExVAT(in: period).priceStr,
                value: $0.perKilo(in: period).priceStr,
                //percentage: (price == 0 ? 0 : $0.avgPricePerKiloExVAT(in: period) / price).formattedPercentage
                percentage: (price == 0 ? 0 : $0.perKilo(in: period).price / price).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Avg Price per kilo", value: price.formattedGrouped, data: data)
    }
    
    func avgCostPerKiloExVATDataPoints(in period: Period) -> DataBlock {
        /// avgCostPerKiloExVAT(in: period)
        let cost = perKilo(in: period).cost.fullCost
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                //value: $0.avgCostPerKiloExVAT(in: period).formattedGrouped,
                //value: $0.avgPerKiloExVAT(in: period).costStr,
                value: $0.perKilo(in: period).cost.fullCostStr,
                //percentage: (cost == 0 ? 0 : $0.avgCostPerKiloExVAT(in: period) / cost).formattedPercentage
                percentage: (cost == 0 ? 0 : $0.perKilo(in: period).cost.fullCost / cost).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Avg Cost per kilo", value: cost.formattedGrouped, data: data)
    }
    
    
    //  MARK: Output (production) Cost Structure Data Points
    
    func productionIngredientCostExVATDataPoints(in period: Period) -> DataBlock {
        let ingredientsStr = produced(in: period).cost.ingredient.valueStr
        let data = bases.map {
            DataPointWithShare(
                title:      $0.name,
                value:      $0.produced(in: period).cost.ingredient.valueStr,
                percentage: $0.produced(in: period).cost.ingredient.percentageStr
            )
        }
        
        return DataBlock(icon: Ingredient.icon, title: "Ingredients", value: ingredientsStr, data: data)
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
        let depreciation = produced(in: period).cost.depreciation.value
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
        let utilities = sold(in: period).cost.utility.value
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: $0.utilitiesExVAT(in: period).formattedGrouped,
                percentage: (utilities == 0 ? 0 : $0.sold(in: period).cost.utility.value / utilities).formattedPercentage
            )
        }
        
        return DataBlock(icon: Utility.icon, title: "Utility", value: utilities.formattedGrouped, data: data)
    }
    
    
    //  MARK: Output (production) Cost Structure Percentage Data Points
    
    func productionCostStructureDataPoints(in period: Period) -> DataBlock {
        let ingredients = produced(in: period).cost.ingredient.percentage
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.produced(in: period).cost.ingredient.percentageStr
            )
        }
        
        return DataBlock(icon: Ingredient.icon, title: "Ingredients", value: ingredients.formattedPercentageWith1Decimal, data: data)
    }
    
    func productionIngredientCostExVATPercentageDataPoints(in period: Period) -> DataBlock {
        let ingredients = produced(in: period).cost.ingredient.percentage
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.produced(in: period).cost.ingredient.percentageStr
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
                percentage: $0.produced(in: period).cost.salary.percentageStr
            )
        }
        
        return DataBlock(icon: Employee.icon, title: "Salary", value: salary.formattedPercentageWith1Decimal, data: data)
    }
    
    func depreciationPercentageDataPoints(in period: Period) -> DataBlock {
        let depreciation = sold(in: period).cost.depreciation.percentage
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.sold(in: period).cost.depreciation.percentageStr
            )
        }
        
        return DataBlock(icon: Equipment.icon, title: "Depreciation", value: depreciation.formattedPercentageWith1Decimal, data: data)
    }
    
    func utilitiesExVATPercentageDataPoints(in period: Period) -> DataBlock {
        let utilities = sold(in: period).cost.utility.percentage
        let data = bases.map {
            DataPointWithShare(
                title: $0.name,
                value: "",
                percentage: $0.sold(in: period).cost.utility.percentageStr
            )
        }
        
        return DataBlock(icon: Utility.icon, title: "Utility", value: utilities.formattedPercentageWith1Decimal, data: data)
    }
    
    
    //  MARK: Margin
    
    func marginDataPoints(in period: Period) -> DataBlock {
        let totalMargin = pnl(in: period).margin
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                //value: $0.totalMargin(in: period).formattedGrouped,
                value: $0.sold(in: period).marginStr,
                //percentage: (totalMargin == 0 ? 0 : $0.totalMargin(in: period) / totalMargin).formattedPercentage
                percentage: $0.sold(in: period).marginPercentageStr
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Margin", value: totalMargin.formattedGrouped, data: data)
    }
    
    func marginPercentageDataPointWithShare(in period: Period) -> DataBlock {
        let marginPercentage = sold(in: period).marginPercentage //pnl(in: period).marginPercentage ?? 0
        let data = products.map {
            DataPointWithShare(
                title: $0.name,
                //value: $0.marginPercentage(in: period).formattedPercentage,
                value: $0.sold(in: period).marginPercentageStr,
                //percentage: (marginPercentage == 0 ? 0 : $0.marginPercentage(in: period) / marginPercentage).formattedPercentage
                percentage: (marginPercentage == 0 ? 0 : $0.sold(in: period).marginPercentage / marginPercentage).formattedPercentage
            )
        }
        
        return DataBlock(icon: "dollarsign.circle", title: "Margin %%", value: sold(in: period).marginPercentageStr, data: data)
    }
}
