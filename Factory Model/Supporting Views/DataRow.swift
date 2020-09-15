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
    
    init(_ item: DataPointWithShare, color: Color? = nil) {
        self.item = item
        self.color = color ?? .secondary
    }
    
    var body: some View {
        HStack {
            Text(item.title)
            
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
