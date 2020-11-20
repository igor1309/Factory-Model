//
//  Warable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.09.2020.
//

import Foundation

//  MARK: - TESTING
/// Base & Product
protocol Warable {
    
    /// Production Qty
    func productionQty(in period: Period) -> Double
    
    /// Sales Qty
    func salesQty(in period: Period) -> Double
    
    /// Unit
    func unit(in period: Period) -> PriceCostMargin
    
    /// Weight Netto
    var weightNetto: Double { get }
    
}

extension Base: Warable {
    
    /// умножить количество первичного продукта в упаковке (baseQty) на производимое количество (productionQty)
    /// Production Qty
    func productionQty(in period: Period) -> Double {
        products.reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.productionQty(in: period) }
    }
    /// Sales Qty
    func salesQty(in period: Period) -> Double {
        products.reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.salesQty(in: period) }
    }
    
    func unit(in period: Period) -> PriceCostMargin {
        
        // MARK: Price ex VAT
        
        /// Sales Qty
        let sales = salesQty(in: period)
        /// Price ex VAT
        let price = sales == 0 ? 0 : revenueExVAT(in: period) / sales

        
        // MARK: Cost Components
        
        /// Ingredient ex VAT
        let ingredient: Double = recipes.reduce(0) { $0 + $1.ingredientsExVAT }
        
        /// total produced base product weight with complexity
        let weightedWeight = factory?.bases
            .map { $0.productionQty(in: period) * $0.weightNetto * $0.complexity }
            .reduce(0, +)
            ?? 0
        
        
        //  MARK: Salary
        
        /// factory production salary
        let productionSalary = factory?.productionSalaryWithTax(in: period) ?? 0
        /// Labor Cost of 1 gram of base product with complexity of 1
        let laborCostOf1GramOfBaseProduct = weightedWeight == 0 ? 0 : productionSalary / weightedWeight
        /// Salary with tax
        let salary: Double = weightNetto * complexity * laborCostOf1GramOfBaseProduct
        
        
        //  MARK: Depreciation
        
        /// factory depreciation
        let factoryDepreciation = factory?.depreciation(in: period) ?? 0
        /// Depreciation of 1 gram of base product with complexity of 1
        let depreciationFor1GramOfBaseProduct = weightedWeight == 0 ? 0 : factoryDepreciation / weightedWeight
        /// Depreciation
        let depreciation: Double = weightNetto * complexity * depreciationFor1GramOfBaseProduct
        
        
        //  MARK: Utility ex VAT
        
        let utility: Double = utilities.reduce(0) { $0 + $1.priceExVAT }
        
        
        //  MARK: full cost ex VAT
        
        let fullCost = ingredient + salary + depreciation + utility
        
        
        //  MARK: String format
        
        let formatWithDecimal = true
        
        return PriceCostMargin(
            price: price,
            cost: Cost(
                title: "Cost per Unit",
                header: "Cost per Unit",
                ingredient: CostComponent(
                    value: ingredient,
                    fullCost: fullCost,
                    formatWithDecimal: formatWithDecimal
                ),
                salary: CostComponent(
                    value: salary,
                    fullCost: fullCost,
                    formatWithDecimal: formatWithDecimal
                ),
                depreciation: CostComponent(
                    value: depreciation,
                    fullCost: fullCost,
                    formatWithDecimal: formatWithDecimal
                ),
                utility: CostComponent(
                    value: utility,
                    fullCost: fullCost,
                    formatWithDecimal: formatWithDecimal
                ),
                formatWithDecimal: formatWithDecimal
            ),
            weightNetto: weightNetto,
            formatWithDecimal: formatWithDecimal
        )
    }
    
}

extension Product: Warable {
    
    /// Production Qty
    func productionQty(in period: Period) -> Double {
        productionQty / self.period.hours * period.hours
    }
    /// Sales Qty
    func salesQty(in period: Period) -> Double {
        sales.reduce(0) { $0 + $1.salesQty(in: period) }
    }
    
    func unit(in period: Period) -> PriceCostMargin {
        
        // MARK: Price ex VAT
        
        /// Sales Qty
        let sales = salesQty(in: period)
        /// Price ex VAT
        let price = sales == 0 ? 0 : revenueExVAT(in: period) / sales
        
        
        // MARK: Cost Components
        
        /// Ingredient ex VAT
        let ingredient: Double = base?.recipes.reduce(0) { $0 + $1.ingredientsExVAT } ?? 0
        
        /// total produced base product weight with complexity
        let weightedWeight = base?.factory?.bases
            .map { $0.productionQty(in: period) * $0.weightNetto * $0.complexity }
            .reduce(0, +)
            ?? 0
        
        
        //  MARK: Salary
        
        /// factory production salary
        let productionSalary = base?.factory?.productionSalaryWithTax(in: period) ?? 0
        /// Labor Cost of 1 gram of base product with complexity of 1
        let laborCostOf1GramOfBaseProduct = weightedWeight == 0 ? 0 : productionSalary / weightedWeight
        /// Weight Netto
        //let weightNetto = (base?.weightNetto ?? 0) * baseQtyInBaseUnit
        /// Salary with tax
        let salary: Double = weightNetto * (base?.complexity ?? 0) * laborCostOf1GramOfBaseProduct
        
        
        //  MARK: Depreciation
        
        /// factory depreciation
        let factoryDepreciation = base?.factory?.depreciation(in: period) ?? 0
        /// Depreciation of 1 gram of base product with complexity of 1
        let depreciationFor1GramOfBaseProduct = weightedWeight == 0 ? 0 : factoryDepreciation / weightedWeight
        /// Depreciation
        let depreciation: Double = weightNetto * (base?.complexity ?? 0) * depreciationFor1GramOfBaseProduct
        
        
        //  MARK: Utility ex VAT
        
        let utility: Double = base?.utilities.reduce(0) { $0 + $1.priceExVAT } ?? 0
        
        
        //  MARK: full cost ex VAT
        
        let fullCost = ingredient + salary + depreciation + utility
        
        
        //  MARK: String format
        
        let formatWithDecimal = true
        
        return PriceCostMargin(
            price: price,
            cost: Cost(
                title: "Cost per Unit",
                header: "Cost per Unit",
                ingredient: CostComponent(
                    value: ingredient,
                    fullCost: fullCost,
                    formatWithDecimal: formatWithDecimal
                ),
                salary: CostComponent(
                    value: salary,
                    fullCost: fullCost,
                    formatWithDecimal: formatWithDecimal
                ),
                depreciation: CostComponent(
                    value: depreciation,
                    fullCost: fullCost,
                    formatWithDecimal: formatWithDecimal
                ),
                utility: CostComponent(
                    value: utility,
                    fullCost: fullCost,
                    formatWithDecimal: formatWithDecimal
                ),
                formatWithDecimal: formatWithDecimal
            ),
            weightNetto: weightNetto,
            formatWithDecimal: formatWithDecimal
        )
    }
    
}

