//
//  ProfitLossStatement.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct ProfitLossStatement: View {
    //    var factory: Factory
    
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
                        FinancialLabel("Sales, ex VAT", value: "TBD", percentage: nil)
                        FinancialLabel("Sales, with VAT", value: "TBD", percentage: nil, font: .caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: header("Production Cost")
                    ) {
                        Group {
                            FinancialLabel("Ingredient Cost, ex VAT", value: "TBD", percentage: "TBD")
                            FinancialLabel("Labor incl taxes", value: "TBD", percentage: "TBD")
                            FinancialLabel("Utilities, ex VAT", value: "TBD", percentage: "TBD")
                            FinancialLabel("Amortization", value: "TBD", percentage: "TBD")
                        }
                        .foregroundColor(.secondary)

                        FinancialLabel("Total Productoin Cost", value: "TBD", percentage: "TBD")
                    }
                    
                    Section(
                        header: header("Margin")
                    ) {
                        FinancialLabel("Margin", value: "TBD", percentage: "TBD")
//                            .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: header("Expenses")
                    ) {
                        FinancialLabel("Expenses, ex VAT", value: "TBD", percentage: "TBD")
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("EBIT")
                    ) {
                        FinancialLabel("EBIT", value: "TBD", percentage: "TBD")
//                            .foregroundColor(.secondary)
                    }
                }
                
                Group {
                    Section(
                        header: header("Taxes")
                    ) {
                        FinancialLabel("Profit Tax", value: "TBD", percentage: "TBD")
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("Net Profit")
                    ) {
                        FinancialLabel("Net Profit", value: "TBD", percentage: "TBD")
                    }
                    
                    Divider()
                    
                    Section(
                        header: header("EBITDA")
                    ) {
                        FinancialLabel("EBITDA", value: "TBD", percentage: "TBD")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}

struct ProfitLossStatement_Previews: PreviewProvider {
    static var previews: some View {
        ProfitLossStatement()
            .preferredColorScheme(.dark)
//            .previewLayout(.fixed(width: 375, height: 1300))
    }
}
