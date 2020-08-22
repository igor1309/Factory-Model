//
//  HBar.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.08.2020.
//

import SwiftUI

struct ColorPercentage: Hashable {
    let color: Color
    let percentage: Double
    
    init(_ color: Color, _ percentage: Double) {
        self.color = color
        self.percentage = percentage
    }
}

struct HBar: View {
    var items: [ColorPercentage]
    
    init(_ items: [ColorPercentage]) {
        self.items = items
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: geo.size.width * CGFloat(item.percentage), height: 12)
                        .foregroundColor(item.color)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }
}
struct HBar_Previews: PreviewProvider {
    static var previews: some View {
        HBar([
            ColorPercentage(Color.blue, 0.3),
            ColorPercentage(.green, 0.2),
            ColorPercentage(.pink, 0.1),
            ColorPercentage(.orange, 0.4),
        ])
        .preferredColorScheme(.dark)
        .padding()
    }
}
