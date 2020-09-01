//
//  DataView.swift
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

struct DataView: View {
    let icon: String
    let title: String
    let data: [DataPointWithShare]
    let hBarItems: [ColorPercentage]
    let sum: Double
    
    init(icon: String, title: String, data: [DataPoint]) {
        self.icon = icon
        self.title = title
        
        let sum = data.reduce(0) { $0 + $1.value }
        
        let points = data.map {
            DataPointWithShare(
                id: $0.id,
                title: $0.title,
                value: $0.value,
                percentage: $0.value / sum
            )
        }
        
        let items = data.map {
            ColorPercentage(
                Color.random,
                $0.value / sum
            )
        }
        
        self.sum = sum
        self.hBarItems = items
        self.data = points
    }
    
    init(icon: String, title: String, data: [DataPointWithShare]) {
        self.icon = icon
        self.title = title
        self.data = data
        
        let sum = data.reduce(0) { $0 + $1.value }
                
        let items = data.map {
            ColorPercentage(
                Color.random,
                $0.value / sum
            )
        }
        
        self.sum = sum
        self.hBarItems = items
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            LabelWithDetail(icon, title, sum.formattedGrouped)
                .font(.subheadline)
                .padding(.bottom, 4)

            // HBar(hBarItems)
            
            ForEach(data) { item in
                row(item)
            }
        }
    }
    
    private func row(_ item: DataPointWithShare) -> some View {
        HStack {
            Text(item.title)
//                .padding(.leading)
            
            Spacer()
            
            Text(item.value.formattedGrouped)
            
            ZStack(alignment: .trailing) {
                Text(2.formattedPercentage).hidden()
                Text(item.percentage.formattedPercentage)
            }
        }
        .foregroundColor(.secondary)
        .font(.footnote)
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(
            icon: "square.stack.3d.up",
            title: "Revenue",
            data: [
                DataPoint(title: "Product 1", value: 123),
                DataPoint(title: "Product 2", value: 223),
                DataPoint(title: "Product 3", value: 423)
            ]
        )
        .padding(.horizontal)
        .preferredColorScheme(.dark)
    }
}
