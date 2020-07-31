//
//  ProfitLossStatement.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct ProfitLossStatement: View {
    //    var factory: Factory
    
    var body: some View {
        
        List {
            Group {
                Group {
                    Section(
                        header: Text("Revenue")
                    ) {
                        LabelWithDetail("square", "Sales ex VAT", "TBD")
                        LabelWithDetail("square", "Sales with VAT", "TBD")
                            .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: Text("Production Cost")
                    ) {
                        Group {
                            LabelWithDetail("square", "Feedstock Cost ex VAT", "TBD")
                            LabelWithDetail("square", "Labor incl taxes", "TBD")
                            LabelWithDetail("square", "Utilities ex VAT", "TBD")
                            LabelWithDetail("square", "Amortization", "TBD")
                        }
                        .foregroundColor(.secondary)
                        
                        LabelWithDetail("square", "Total Productoin Cost", "TBD")
                        LabelWithDetail("square", "Total Productoin Cost, %", "TBD")
                            .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: Text("Margin")
                    ) {
                        LabelWithDetail("square", "Margin", "TBD")
                        LabelWithDetail("square", "Margin, %", "TBD")
                            .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: Text("Expenses")
                    ) {
                        LabelWithDetail("square", "Expenses ex VAT", "TBD")
                        LabelWithDetail("square", "Expenses ex VAT, %", "TBD")
                            .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: Text("EBIT")
                    ) {
                        LabelWithDetail("square", "EBIT", "TBD")
                        LabelWithDetail("square", "EBIT, %", "TBD")
                            .foregroundColor(.secondary)
                    }
                }
                .font(.subheadline)
                
                Group {
                    Section(
                        header: Text("Taxes")
                    ) {
                        LabelWithDetail("square", "Profit Tax", "TBD")
                    }
                    
                    Section(
                        header: Text("Net Profit")
                    ) {
                        LabelWithDetail("square", "Net Profit", "TBD")
                        LabelWithDetail("square", "Net Profit, %", "TBD")
                            .foregroundColor(.secondary)
                    }
                    
                    Section(
                        header: Text("EBITDA")
                    ) {
                        LabelWithDetail("square", "EBITDA", "TBD")
                        LabelWithDetail("square", "EBITDA, %", "TBD")
                            .foregroundColor(.secondary)
                    }
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct ProfitLossStatement_Previews: PreviewProvider {
    static var previews: some View {
        ProfitLossStatement()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 1300))
    }
}
