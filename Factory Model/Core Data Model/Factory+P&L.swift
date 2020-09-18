//
//  Factory+P&L.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation

extension Factory {
    
    func revenueExVAT(of group: String, in period: Period) -> Double {
        bases
            .flatMap(\.products)
            .compactMap(\.base)
            .filter { $0.group == group }
            .reduce(0) { $0 + $1.revenueExVAT(in: period) }
    }

    
    //  MARK: P&L

    func pnl(in period: Period) -> PNL {
        PNL(
            revenue: revenueExVAT(in: period),
            salesCost: salesCost(in: period).costExVAT,
            nonProductionSalaryWithTax: nonProductionSalaryWithTax(in: period),
            expensesExVAT: expensesExVAT(in: period),
            depreciationMonthly: depreciationMonthly,
            profitTaxRate: profitTaxRate
        )
    }
    
}
