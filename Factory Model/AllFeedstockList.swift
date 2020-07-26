//
//  AllFeedstockList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AllFeedstockList: View {
    @Environment(\.managedObjectContext) var сontext
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Total"),
                footer: Text("To edit Feedstocks go to Base")
            ) {
                LabelWithDetail("puzzlepiece", "Feedstock Cost", factory.totalFeedstockCostExVAT.formattedGrouped)
                    .font(.subheadline).foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Feedstocks")) {
                ForEach(factory.feedstocksByGroups()) { something in
                    ListRow(something)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Feedstock")
    }
}
