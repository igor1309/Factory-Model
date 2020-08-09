//
//  ProfitLossStatement.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct ProfitLossStatement: View {
    var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    private func header(_ text: String) -> some View {
        Text(text.uppercased())
            .foregroundColor(.tertiary)
            .font(.caption)
            .padding(.top)
    }
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Group {
                    Section(
                        header: header("Revenue")
                    ) {
                        FinancialLabel("Sales, ex VAT", value: factory.revenueExVAT, percentage: nil)
                        FinancialLabel("Sales, with VAT", value: factory.revenueWithVAT, percentage: nil, font: .caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: header("COGS")
                    ) {
                        Group {
                            FinancialLabel(
                                "Ingredient Cost, ex VAT",
                                value:      factory.salesIngredientCostExVAT,
                                percentage: factory.salesIngredientCostExVATPercentage
                            )
                            FinancialLabel(
                                "Salary incl taxes",
                                value: factory.productionSalaryWithTax,
                                percentage: factory.productionSalaryWithTaxPercentage
                            )
                            FinancialLabel("Utilities, ex VAT", value: factory.utilitiesExVAT, percentage: factory.utilitiesExVATPercentage)
                            FinancialLabel("Depreciation", value: factory.depreciationMonthly, percentage: factory.depreciationMonthlyPercentage)
                        }
                        .foregroundColor(.secondary)
                        
                        FinancialLabel(
                            "COGS",
                            value:      factory.cogsExVAT,
                            percentage: factory.cogsExVATPercentage
                        )
                    }
                    
                    Section(
                        header: header("Margin")
                    ) {
                        FinancialLabel("Margin", value: factory.margin, percentage: factory.marginPercentage)
                            .foregroundColor(factory.margin > 0 ? .primary : .systemRed)
                    }
                    
                    Section(
                        header: header("Expenses")
                    ) {
                        Group {
                            FinancialLabel("Non Production Salary incl taxes", value: factory.nonProductionSalaryWithTax, percentage: factory.nonProductionSalaryWithTaxPercentage)
                            FinancialLabel("Expenses, ex VAT", value: factory.expensesExVAT, percentage: factory.expensesExVATPercentage)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("EBIT")
                    ) {
                        FinancialLabel("EBIT", value: factory.ebit, percentage: factory.ebitPercentage)
                            .foregroundColor(factory.ebit > 0 ? .primary : .systemRed)
                    }
                }
                
                Group {
                    Section(
                        header: header("Taxes")
                    ) {
                        FinancialLabel("Profit Tax", value: factory.profitTax, percentage: factory.profitTaxPercentage)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("Net Profit")
                    ) {
                        FinancialLabel("Net Profit", value: factory.netProfit, percentage: factory.netProfitPercentage)
                            .foregroundColor(factory.netProfit > 0 ? .primary : .systemRed)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("EBITDA")
                    ) {
                        FinancialLabel("EBITDA", value: factory.ebitda, percentage: factory.ebitdaPercentage)
                            .foregroundColor(factory.ebitda > 0 ? .primary : .systemRed)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("Salary")
                    ) {
                        Group {
                            FinancialLabel("Production Salary", value: factory.productionSalaryWithTax, percentage: factory.productionSalaryWithTaxPercentage)
                            FinancialLabel("Non Production Salary", value: factory.nonProductionSalaryWithTax, percentage: factory.nonProductionSalaryWithTaxPercentage)
                        }
                        .foregroundColor(.secondary)
                        
                        FinancialLabel("Total Salary incl taxes", value: factory.salaryWithTax, percentage: factory.salaryWithTaxPercentage)
                    }
                }
            }
            .padding()
        }
    }
}

//struct ProfitLossStatement_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfitLossStatement)
//            .preferredColorScheme(.dark)
//        //            .previewLayout(.fixed(width: 375, height: 1300))
//    }
//}
