//
//  PNL.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.09.2020.
//

import Foundation

struct PNL {
    
    /// - Parameters:
    ///   - revenue: Revenue ex VAT
    ///   - salesCost: Cost of Goods Sold
    ///   - nonProductionSalaryWithTax: Salary of non-production Departments
    ///   - expensesExVAT: Expenses ex VAT
    init(
        revenue: Double,
        salesCost: Double,
        nonProductionSalaryWithTax: Double,
        expensesExVAT: Double,
        depreciationMonthly: Double,
        profitTaxRate: Double
    ) {
        //  MARK: Margin, EBIT, EBITDA
        
        margin = revenue - salesCost
        marginPercentage = revenue > 0 ? margin / revenue : nil
        
        ebit = margin - nonProductionSalaryWithTax - expensesExVAT
        ebitPercentage = revenue > 0 ? ebit / revenue : nil
        
        ebitda = ebit + depreciationMonthly
        ebitdaPercentage = revenue > 0 ? ebitda / revenue : nil
        
        
        //  MARK: Profit Tax
        
        profitTax = ebit > 0 ? ebit * profitTaxRate : 0
        profitTaxPercentage = revenue > 0 ? profitTax / revenue : nil
        
        
        //  MARK: Net Profit
        
        netProfit = ebit - profitTax
        netProfitPercentage = revenue > 0 ? netProfit / revenue : nil
    }
    
    
    //  MARK: Margin, EBIT, EBITDA
    
    let margin: Double
    var marginPercentage: Double?
    
    var ebit: Double
    var ebitPercentage: Double?
    
    var ebitda: Double
    var ebitdaPercentage: Double?
    
    
    //  MARK: Profit Tax
    
    var profitTax: Double
    var profitTaxPercentage: Double?
    
    
    //  MARK: Net Profit
    
    var netProfit: Double
    var netProfitPercentage: Double?
}
