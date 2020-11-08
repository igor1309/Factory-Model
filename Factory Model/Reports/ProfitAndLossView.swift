//
//  ProfitAndLossView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct ProfitAndLossView: View {
    @EnvironmentObject var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    private func header(_ text: String) -> some View {
        Text(text.uppercased())
            .foregroundColor(.tertiary)
            .font(.caption)
            .padding(.top)
    }
    
    private var salesCost: Cost { factory.sold(in: settings.period).cost }
    
    private var pnl: PNL { factory.pnl(in: settings.period) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Group {
                    Section(
                        header: header("Revenue")
                    ) {
                        FinancialRow(
                            "Sales, ex VAT",
                            value: factory.revenueExVAT(in: settings.period),
                            percentage: nil
                        )
                        FinancialRow(
                            "Sales, with VAT",
                            value: factory.revenueWithVAT(in: settings.period),
                            percentage: nil, font: .caption
                        )
                        .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: header("COGS")
                    ) {
                        Group {
                            FinancialRow(
                                "Ingredient Cost, ex VAT",
                                value:      salesCost.ingredient.value,
                                percentage: salesCost.ingredient.percentage
                            )
                            FinancialRow(
                                "Salary incl taxes",
                                value:      salesCost.salary.value,
                                percentage: salesCost.salary.percentage
                            )
                            FinancialRow(
                                "Depreciation",
                                value:      factory.depreciation(in: settings.period).formattedGrouped,
                                percentage: "TBD"
                            )
                            FinancialRow(
                                "Utilities, ex VAT",
                                value:      salesCost.utility.value,
                                percentage: salesCost.utility.percentage
                            )
                        }
                        .foregroundColor(.secondary)
                        
                        FinancialRow(
                            "COGS",
                            value:      salesCost.fullCost,
                            percentage: salesCost.utility.percentage
                        )
                    }
                    
                    Section(
                        header: header("Margin")
                    ) {
                        FinancialRow(
                            "Margin",
                            value:      pnl.margin,
                            percentage: pnl.marginPercentage
                        )
                        .foregroundColor(pnl.margin > 0 ? .primary : .systemRed)
                    }
                    
                    Section(
                        header: header("Expenses")
                    ) {
                        Group {
                            FinancialRow(
                                "Non Production Salary incl taxes",
                                value:      factory.nonProductionSalaryWithTax(in: settings.period),
                                percentage: factory.nonProductionSalaryWithTaxPercentage(in: settings.period)
                            )
                            FinancialRow(
                                "Expenses, ex VAT",
                                value:      factory.expensesExVAT(in: settings.period),
                                percentage: factory.expensesExVATPercentage(in: settings.period)
                            )
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("EBIT")
                    ) {
                        FinancialRow(
                            "EBIT",
                            value:      pnl.ebit,
                            percentage: pnl.ebitPercentage
                        )
                        .foregroundColor(pnl.ebit > 0 ? .primary : .systemRed)
                    }
                }
                
                Group {
                    Section(
                        header: header("Taxes")
                    ) {
                        FinancialRow(
                            "Profit Tax",
                            /// factory.profitTax(in: settings.period)
                            value:      pnl.profitTax,
                            /// factory.profitTaxPercentage(in: settings.period)
                            percentage: pnl.profitTaxPercentage
                        )
                        .foregroundColor(pnl.profitTax > 0 ? .primary : .secondary)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("Net Profit")
                    ) {
                        FinancialRow(
                            "Net Profit",
                            /// netProfit(in: settings.period)
                            value:      pnl.netProfit,
                            /// factory.netProfitPercentage(in: settings.period)
                            percentage: pnl.netProfitPercentage
                        )
                        .foregroundColor(pnl.netProfit > 0 ? .primary : .systemRed)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("EBITDA")
                    ) {
                        FinancialRow(
                            "EBITDA",
                            value:      pnl.ebitda,
                            percentage: pnl.ebitdaPercentage
                        )
                        .foregroundColor(pnl.ebitda > 0 ? .primary : .systemRed)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("Salary")
                    ) {
                        Group {
                            FinancialRow(
                                "Production Salary",
                                value:      factory.produced(in: settings.period).cost.salary.value,
                                percentage: factory.produced(in: settings.period).cost.salary.percentage
                            )
                            FinancialRow(
                                "Non Production Salary",
                                value:      factory.nonProductionSalaryWithTax(in: settings.period),
                                percentage: factory.nonProductionSalaryWithTaxPercentage(in: settings.period)
                            )
                        }
                        .foregroundColor(.secondary)
                        
                        FinancialRow(
                            "Salary incl taxes",
                            value:      factory.salaryWithTax(in: settings.period),
                            percentage: factory.salaryWithTaxPercentage(in: settings.period)
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

struct ProfitAndLossView_Previews: PreviewProvider {
    static var previews: some View {
        ProfitAndLossView(for: Factory.example)
            .environmentObject(Settings())
            .preferredColorScheme(.dark)
    }
}
