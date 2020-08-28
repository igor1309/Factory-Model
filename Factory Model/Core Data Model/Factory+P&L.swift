//
//  Factory+P&L.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation

extension Factory {
    
    //  MARK: - Revenue
    
    ///  reducing by buyers is not correct - Buyer could not be exclusively linked to factory
    ///  reducing via bases is a right way to go
    func revenueExVAT(in period: Period) -> Double {
        bases
            .flatMap(\.products)
            .reduce(0) { $0 + $1.revenueExVAT(in: period) }
    }
    
    func revenueWithVAT(in period: Period) -> Double {
        bases
            .flatMap(\.products)
            .reduce(0) { $0 + $1.revenueWithVAT(in: period) }
    }
    
    func revenueExVAT(of group: String, in period: Period) -> Double {
        bases
            .flatMap(\.products)
            .compactMap(\.base)
            .filter { $0.group == group }
            .reduce(0) { $0 + $1.revenueExVAT(in: period) }
    }
    
    
    //  MARK: - Margin, EBIT, EBITDA
    
    func margin(in period: Period) -> Double {
        revenueExVAT(in: period) - cogsExVAT(in: period)
    }
    func marginPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? margin(in: period) / revenue : nil
    }
    
    func ebit(in period: Period) -> Double {
        margin(in: period) - nonProductionSalaryWithTax(in: period) - expensesExVAT(in: period)
    }
    func ebitPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? ebit(in: period) / revenue : nil
    }
    
    func ebitda(in period: Period) -> Double {
        ebit(in: period) + depreciationMonthly
    }
    func ebitdaPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? ebitda(in: period) / revenue : nil
    }

    
    //  MARK: - Profit Tax
    func profitTax(in period: Period) -> Double {
        let earnings = ebit(in: period)
        return earnings > 0 ? earnings * profitTaxRate : 0
    }
    func profitTaxPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? profitTax(in: period) / revenue : nil
    }
    
    
    //  MARK: - Net Profit
    func netProfit(in period: Period) -> Double {
        ebit(in: period) - profitTax(in: period)
    }
    func netProfitPercentage(in period: Period) -> Double? {
        let revenue = revenueExVAT(in: period)
        return revenue > 0 ? netProfit(in: period) / revenue : nil
    }
    

}
