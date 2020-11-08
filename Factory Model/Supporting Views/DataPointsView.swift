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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(dataBlock.title).font(.subheadline)
                Spacer()
                Text(dataBlock.value)
                Text((-2).formattedPercentageWith1Decimal).hidden()
            }
            .font(.footnote)
            
            ForEach(dataBlock.data) { item in
                FinancialRow(item)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 3)
    }
}

struct DataPointsView2: View {
    var dataBlock: DataBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(dataBlock.title).font(.subheadline)
                Spacer()
                Text(dataBlock.value)
                //  Text((-2).formattedPercentage).hidden()
            }
            .font(.footnote)
            
            ForEach(dataBlock.data) { item in
                FinancialRow(item)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 3)
    }    
}

struct DataPointsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header: Text("DataPointsView")) {
                    DataPointsView(dataBlock: DataBlock.example)
                }
                
                Section(header: Text("DataPointsView2")) {
                    DataPointsView2(dataBlock: DataBlock.example)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .environment(\.colorScheme, .dark)
    }
}
