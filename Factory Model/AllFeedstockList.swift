//
//  AllFeedstockList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AllFeedstockList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Production"),
                footer: Text("To edit Feedstocks go to Product")
            ) {
                LabelWithDetail("puzzlepiece", "Total Feedstock Cost", factory.totalFeedstockCost.formattedGrouped)
                    .font(.subheadline).foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Feedstocks")) {
                ForEach(factory.feedstocksByGroups()) { feedstock in
                    ListRow(
                        title: feedstock.name,
                        subtitle: "qty: \(feedstock.qty.formattedGrouped) | cost: \(feedstock.cost.formattedGrouped)",
                        detail: feedstock.products,
                        icon: "puzzlepiece",
                        useSmallerFont: true
                    )
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Feedstock")
    }
}

//struct AllFeedstockList_Previews: PreviewProvider {
//    static var previews: some View {
//        AllFeedstockList()
//    }
//}
