//
//  DataRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 14.09.2020.
//

import SwiftUI

struct DataRow: View {
    let item: DataPointWithShare
    let color: Color
    let icon: String
    
    init(
        _ item: DataPointWithShare,
        color: Color? = nil,
        icon: String? = nil
    ) {
        self.item = item
        self.color = color ?? .secondary
        self.icon = icon ?? ""
    }
    
    var body: some View {
        HStack {
            if icon.isEmpty {
                Text(item.title)
            } else {
                Label {
                    Text(item.title)
                } icon: {
                    Image(systemName: icon)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Text(item.value)
            
            ZStack(alignment: .trailing) {
                Text((-2).formattedPercentage).hidden()
                Text(item.percentage)
            }
        }
        .foregroundColor(color)
        .font(.footnote)
    }
}

struct DataRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DataRow(
                DataPointWithShare(
                    title: "Test",
                    value: 1_224.formattedGrouped,
                    percentage: 0.12.formattedPercentage
                )
            )
            
            Divider()
            
            DataRow(
                DataPointWithShare(
                    title: "Test",
                    value: 1_224.formattedGrouped,
                    percentage: 0.12.formattedPercentage
                ),
                color: Ingredient.color
            )
            
            Divider()
            
            DataRow(
                DataPointWithShare(
                    title: "Test",
                    value: 1_224.formattedGrouped,
                    percentage: 0.12.formattedPercentage
                ),
                color: Ingredient.color,
                icon: Ingredient.icon
            )
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
