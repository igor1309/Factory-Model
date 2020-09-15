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
                DataRow(item)
            }
        }
    }
}

struct DataPointsView2: View {
    var dataBlock: DataBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(dataBlock.title).font(.subheadline)
                Spacer()
                Text(dataBlock.value)
                //  Text((-2).formattedPercentage).hidden()
            }
            .font(.footnote)
            
            ForEach(dataBlock.data) { item in
                DataRow(item)
            }
        }
    }    
}
