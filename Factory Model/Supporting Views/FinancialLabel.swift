//
//  FinancialLabel.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct FinancialLabel: View {
    
    var title: String
    var value: String
    var percentage: String
    var font: Font
    
    init(
        _ title: String,
        value: String,
        percentage: String?,
        font: Font = .subheadline
    ) {
        self.title = title
        self.value = value
        self.percentage = percentage == nil ? "" : percentage!
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
        self.percentage = percentage == nil ? "" : percentage!.formattedPercentageWith1Decimal
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
    static var previews: some View {
        VStack {
            FinancialLabel("Row Title", value: 1_000_000.formattedGrouped, percentage: nil)
            FinancialLabel("Row Title", value: 1_000_000.formattedGrouped, percentage: 0.13.formattedPercentageWith1Decimal, font: .caption)
            FinancialLabel("Row Title", value: 30_000_000, percentage: 0.25)
            FinancialLabel("Row Title", value: 1_000_000.formattedGrouped, percentage: 0.95.formattedPercentageWith1Decimal)
            FinancialLabel("Row Title", value: 30_000_000, percentage: 0.25)
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
