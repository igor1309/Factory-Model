//
//  AllFeedstockList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AllFeedstockList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var feedstocks: FetchedResults<Feedstock>
    @FetchRequest private var orphans: FetchedResults<Feedstock>
    @FetchRequest private var allFeedstocks: FetchedResults<Feedstock>

    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
        _feedstocks = Feedstock.defaultFetchRequest(for: factory)
        _orphans = FetchRequest(
            entity: Feedstock.entity(),
            sortDescriptors: Feedstock.defaultSortDescriptors,
            predicate: NSPredicate(
                format: "ANY %K.base == nil", #keyPath(Feedstock.ingredients_)
            )
        )
        _allFeedstocks = Feedstock.defaultFetchRequest()
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Total")
            ) {
                LabelWithDetail("puzzlepiece", "Feedstock Cost", factory.totalFeedstockCostExVAT.formattedGrouped)
                    .font(.subheadline).foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            if !feedstocks.isEmpty {
                ListRow(feedstocks.first!)
            }
            
            GenericListSection(fetchRequest: _feedstocks) { feedstock in
                FeedstockView(feedstock: feedstock)
            }
            
            Text("Orphans")
            GenericListSection(fetchRequest: _orphans) { feedstock in
                FeedstockView(feedstock: feedstock)
            }
            
            Text("All Feedstocks @ all Factories")
            GenericListSection(fetchRequest: _allFeedstocks) { feedstock in
                FeedstockView(feedstock: feedstock)
            }
            

            Section(header: Text("Feedstocks")) {
                Text("TBD: REDO - see code")
                    .foregroundColor(.systemRed)
                    .font(.subheadline)
                //ForEach(factory.feedstocksByGroups()) { something in
                  //  ListRow(something)
                //}
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Feedstock")
        .navigationBarItems(trailing: PlusButton(childType: Feedstock.self))
    }
}
