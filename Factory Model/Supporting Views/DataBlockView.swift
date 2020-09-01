//
//  DataBlockView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct DataBlockView: View {
    var dataBlock: DataBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label(dataBlock.title, systemImage: dataBlock.icon)
                .font(.subheadline)
                .padding(.bottom, 3)
            
            ForEach(dataBlock.data) { item in
                row(item)
            }
            
            Divider().padding(.vertical, 3)
            
            HStack {
                Spacer()
                Text(dataBlock.value)
                Text((-2).formattedPercentage).hidden()
            }
            .font(.footnote)
        }
    }
    
    private func row(_ item: DataPointWithShare) -> some View {
        HStack {
            Text(item.title)
            
            Spacer()
            
            Text(item.value)
            
            ZStack(alignment: .trailing) {
                Text((-2).formattedPercentage).hidden()
                Text(item.percentage)
            }
        }
        .foregroundColor(.secondary)
        .font(.footnote)
    }
}