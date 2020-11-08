//
//  FinListRowAndFinancialRow_Previews.swift
//  Factory Model
//
//  Created by Igor Malyarov on 08.11.2020.
//

import SwiftUI

struct FinListRowAndFinancialRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header: Text("FinListRow")) {
                    FinListRow(systemName: "speedometer", title: "Test Row", detail: 1_000_000.formattedGrouped, percentage: 0.12.formattedPercentage, color: .green)
                    FinListRow(systemName: "speedometer", title: "Very very very long Row Title", detail: 1_000_000.formattedGrouped, percentage: 0.12.formattedPercentage, color: .green)
                    
                    FinListRow(type: Base.self, title: "Test Row", detail: 1_000_000.formattedGrouped, percentage: 0.12.formattedPercentage)
                }
                
                Section(header: Text("FinancialLabel")) {
                    FinancialRow("Row Title", value: 1_000_000.formattedGrouped, percentage: nil)
                    FinancialRow("Very very very long Row Title", value: 1_000_000.formattedGrouped, percentage: nil)
                    
                    FinancialRow("Row Title", value: 1_000_000.formattedGrouped, percentage: 0.13.formattedPercentageWith1Decimal, font: .caption)
                    
                    FinancialRow("Row Title", value: 30_000_000, percentage: 0.25)
                    FinancialRow("Row Title", value: 30_000_000, percentage: 0.25, font: .headline)
                    
                    FinancialRow("Row Title", value: 1_000_000.formattedGrouped, percentage: 0.95.formattedPercentageWith1Decimal)
                    FinancialRow("Very very very long Row Title", value: 30_000_000, percentage: 1.25)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("FinListRow and FinancialRow", displayMode: .inline)
        }
        .preferredColorScheme(.dark)
    }
}
