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
        VStack(alignment: .leading, spacing: 4) {
            Label(dataBlock.title, systemImage: dataBlock.icon)
                .font(.subheadline)
                .padding(.bottom, 3)
            
            ForEach(dataBlock.data) { item in
                FinancialRow(item)
                    .foregroundColor(.secondary)
            }
            
            Divider().padding(.vertical, 3)
            
            HStack {
                Spacer()
                Text(dataBlock.value)
                Text((-2).formattedPercentageWith1Decimal).hidden()
            }
            .font(.footnote)
        }
        .padding(.vertical, 3)
    }
}


struct DataBlockView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DataBlockView(dataBlock: DataBlock.example)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Test Factory", displayMode: .inline)
        }
        .preferredColorScheme(.dark)
    }
}
