//
//  FinListRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.08.2020.
//

import SwiftUI

struct FinListRow: View {
    let systemName: String
    let title: String
    let detail: String
    let percentage: String
    let color: Color
    
    init(
        systemName: String,
        title: String,
        detail: String,
        percentage: String,
        color: Color
    ) {
        self.systemName = systemName
        self.title = title
        self.detail = detail
        self.percentage = percentage
        self.color = color
    }
    
    /// using `Type` to get `icon` and `color`
    init<T: Summarizable>(
        type: T.Type,
        title: String,
        detail: String,
        percentage: String
    ) {
        self.systemName = T.icon
        self.title = title
        self.detail = detail
        self.percentage = percentage
        self.color = T.color
    }
    
    var body: some View {
        Label {
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(title)
                
                Spacer()
                
                Text(detail)
                
                ZStack(alignment: .trailing) {
                    Text(2.formattedPercentageWith1Decimal).hidden()
                    Text(percentage)
                }
            }
        } icon: {
            Image(systemName: systemName)
        }
        .foregroundColor(color)
    }
}

struct FinLabel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section {
                    FinListRow(systemName: "speedometer", title: "Test Row", detail: 1_000_000.formattedGrouped, percentage: 0.12.formattedPercentage, color: .green)
                }
                
                FinListRow(systemName: "speedometer", title: "Test Row", detail: 1_000_000.formattedGrouped, percentage: 0.12.formattedPercentage, color: .green)
                
                FinListRow(type: Base.self, title: "Test Row", detail: 1_000_000.formattedGrouped, percentage: 0.12.formattedPercentage)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("FinListRow", displayMode: .inline)
        }
        .environment(\.colorScheme, .dark)
    }
}
