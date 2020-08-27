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
    var revenueExVAT: Double {
        bases
            .flatMap(\.products)
            .reduce(0) { $0 + $1.revenueExVAT }
    }
    
    var revenueWithVAT: Double {
        bases
            .flatMap(\.products)
            .reduce(0) { $0 + $1.revenueWithVAT }
    }
    
    func revenueExVAT(for group: String) -> Double {
        bases
            .flatMap(\.products)
            .compactMap(\.base)
            .filter { $0.group == group }
            .map(\.revenueExVAT)
            .reduce(0, +)
    }
    
    
    //  MARK: - Margin, EBIT, EBITDA
    
    var margin: Double {
        revenueExVAT - cogsExVAT
    }
    var marginPercentage: Double? {
        revenueExVAT > 0 ? margin / revenueExVAT : nil
    }
    
    var ebit: Double {
        margin - nonProductionSalaryWithTax - expensesExVAT
    }
    var ebitPercentage: Double? {
        revenueExVAT > 0 ? ebit / revenueExVAT : nil
    }
    
    var ebitda: Double {
        ebit + depreciationMonthly
    }
    var ebitdaPercentage: Double? {
        revenueExVAT > 0 ? ebitda / revenueExVAT : nil
    }

    
    //  MARK: - Profit Tax
    var profitTax: Double {
        ebit > 0 ? ebit * profitTaxRate : 0
    }
    var profitTaxPercentage: Double? {
        revenueExVAT > 0 ? profitTax / revenueExVAT : nil
    }
    
    
    //  MARK: - Net Profit
    var netProfit: Double {
        ebit - profitTax
    }
    var netProfitPercentage: Double? {
        revenueExVAT > 0 ? netProfit / revenueExVAT : nil
    }
    

}
