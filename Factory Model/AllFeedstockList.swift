//
//  AllFeedstockList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AllFeedstockList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Total"),
                footer: Text("To edit Feedstocks go to Product")
            ) {
                LabelWithDetail("puzzlepiece", "Feedstock Cost", factory.totalFeedstockCost.formattedGrouped)
                    .font(.subheadline).foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Feedstocks")) {
                ForEach(factory.feedstocksByGroups()) { feedstock in
                    SomethingRow(feedstock, icon: "puzzlepiece")
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
