//
//  FinLabel.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.08.2020.
//

import SwiftUI

struct FinLabel: View {
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
