//
//  FinancialRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct FinancialRow: View {
    
    var title: String
    var value: String
    var percentage: String
    var font: Font
    
    init(
        _ item: DataPointWithShare,
        font: Font = .footnote
    ) {
        title = item.title
        value = item.value
        percentage = item.percentage
        self.font = font
    }
    
    init(
        _ title: String,
        value: String,
        percentage: String?,
        font: Font = .subheadline
    ) {
        self.title = title
        self.value = value
        self.percentage = percentage ?? ""
        self.font = font
    }
    
    init(
        _ title: String,
        value: Double,
        percentage: Double?,
        font: Font = .subheadline
    ) {
        self.title = title
        self.value = value.formattedGrouped
        self.percentage = percentage?.formattedPercentageWith1Decimal ?? ""
        self.font = font
    }
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(title)
            
            Spacer()
            
            Text(value)
            
            ZStack(alignment: .trailing) {
                Text(2.formattedPercentageWith1Decimal)
                    .font(.subheadline)
                    .hidden()
                Text(percentage)
            }
        }
        .font(font)
    }
}

struct FinancialLabel_Previews: PreviewProvider {
    static var group: some View {
        Group {
            Section(header: Text("DataPointWithShare")) {
                FinancialRow(DataPointWithShare.example, font: .subheadline)
                FinancialRow(DataPointWithShare.example)
                FinancialRow(DataPointWithShare.example, font: .caption)
            }
            
            Section(header: Text("other")) {
                FinancialRow("Row Title", value: 1_000_000.formattedGrouped, percentage: nil)
                FinancialRow("Row Title", value: 1_000_000.formattedGrouped, percentage: 0.13.formattedPercentageWith1Decimal, font: .caption)
                FinancialRow("Row Title", value: 30_000_000, percentage: 0.25)
                FinancialRow("Row Title", value: 1_000_000.formattedGrouped, percentage: 0.95.formattedPercentageWith1Decimal)
                FinancialRow("Row Title", value: 30_000_000, percentage: 0.25)
            }
        }
    }
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    group
                }
                .navigationBarTitle("in Form", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 345.0, height: 550))
            
            NavigationView {
                ScrollView {
                    VStack {
                        group
                    }
                    .padding()
                }
                .navigationBarTitle("in VStack", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 345.0, height: 420))
        }
        .preferredColorScheme(.dark)
    }
}
