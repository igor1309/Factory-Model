//
//  ProfitLossStatement.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct ProfitLossStatement: View {
    let factory: Factory
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    private func header(_ text: String) -> some View {
        Text(text.uppercased())
            .foregroundColor(.tertiary)
            .font(.caption)
            .padding(.top)
    }
    
    private var salesCost: Cost { factory.salesCost(in: period) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Group {
                    Section(
                        header: header("Revenue")
                    ) {
                        FinancialLabel(
                            "Sales, ex VAT",
                            value: factory.revenueExVAT(in: period),
                            percentage: nil
                        )
                        FinancialLabel(
                            "Sales, with VAT",
                            value: factory.revenueWithVAT(in: period),
                            percentage: nil, font: .caption
                        )
                        .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: header("COGS")
                    ) {
                        Group {
                            FinancialLabel(
                                "Ingredient Cost, ex VAT",
                                value:      salesCost.ingredientCostExVAT,
                                percentage: salesCost.ingredientCostExVATPercentage
                            )
                            FinancialLabel(
                                "Salary incl taxes",
                                value:      salesCost.salaryWithTax,
                                percentage: salesCost.salaryWithTaxPercentage
                            )
                            FinancialLabel(
                                "Depreciation",
                                value:      factory.depreciationMonthly,
                                percentage: factory.depreciationMonthlyPercentage(in: period)
                            )
                            FinancialLabel(
                                "Utilities, ex VAT",
                                value:      salesCost.utilityCostExVAT,
                                percentage: salesCost.utilityCostExVATPercentage
                            )
                        }
                        .foregroundColor(.secondary)
                        
                        FinancialLabel(
                            "COGS",
                            value:      salesCost.costExVAT,
                            percentage: salesCost.utilityCostExVATPercentage
                        )
                    }
                    
                    Section(
                        header: header("Margin")
                    ) {
                        FinancialLabel(
                            "Margin",
                            value:      factory.margin(in: period),
                            percentage: factory.marginPercentage(in: period)
                        )
                        .foregroundColor(factory.margin(in: period) > 0 ? .primary : .systemRed)
                    }
                    
                    Section(
                        header: header("Expenses")
                    ) {
                        Group {
                            FinancialLabel(
                                "Non Production Salary incl taxes",
                                value:      factory.nonProductionSalaryWithTax(in: period),
                                percentage: factory.nonProductionSalaryWithTaxPercentage(in: period)
                            )
                            FinancialLabel(
                                "Expenses, ex VAT",
                                value:      factory.expensesExVAT(in: period),
                                percentage: factory.expensesExVATPercentage(in: period)
                            )
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("EBIT")
                    ) {
                        FinancialLabel(
                            "EBIT",
                            value:      factory.ebit(in: period),
                            percentage: factory.ebitPercentage(in: period)
                        )
                        .foregroundColor(factory.ebit(in: period) > 0 ? .primary : .systemRed)
                    }
                }
                
                Group {
                    Section(
                        header: header("Taxes")
                    ) {
                        FinancialLabel(
                            "Profit Tax",
                            value:      factory.profitTax(in: period),
                            percentage: factory.profitTaxPercentage(in: period)
                        )
                        .foregroundColor(factory.profitTax(in: period) > 0 ? .primary : .secondary)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("Net Profit")
                    ) {
                        FinancialLabel(
                            "Net Profit",
                            value:      factory.netProfit(in: period),
                            percentage: factory.netProfitPercentage(in: period)
                        )
                        .foregroundColor(factory.netProfit(in: period) > 0 ? .primary : .systemRed)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("EBITDA")
                    ) {
                        FinancialLabel(
                            "EBITDA",
                            value:      factory.ebitda(in: period),
                            percentage: factory.ebitdaPercentage(in: period)
                        )
                        .foregroundColor(factory.ebitda(in: period) > 0 ? .primary : .systemRed)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("Salary")
                    ) {
                        Group {
                            FinancialLabel(
                                "Production Salary",
                                value:      factory.productionCost(in: period).salaryWithTax,
                                percentage: factory.productionCost(in: period).salaryWithTaxPercentage
                            )
                            FinancialLabel(
                                "Non Production Salary",
                                value:      factory.nonProductionSalaryWithTax(in: period),
                                percentage: factory.nonProductionSalaryWithTaxPercentage(in: period)
                            )
                        }
                        .foregroundColor(.secondary)
                        
                        FinancialLabel(
                            "Salary incl taxes",
                            value:      factory.salaryWithTax(in: period),
                            percentage: factory.salaryWithTaxPercentage(in: period)
                        )
                    }
                }
            }
            .padding()
            .padding(.bottom)
            .padding(.bottom)
        }
    }
}
