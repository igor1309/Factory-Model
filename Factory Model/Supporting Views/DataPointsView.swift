//
//  DataPointsView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 14.09.2020.
//

import SwiftUI

struct DataPointsView: View {
    var dataBlock: DataBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(dataBlock.title).font(.subheadline)
                Spacer()
                Text(dataBlock.value)
                Text((-2).formattedPercentage).hidden()
            }
            .font(.footnote)
            
            ForEach(dataBlock.data) { item in
                row(item)
            }
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
