//
//  FeedstockList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct FeedstockList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var feedstocks: FetchedResults<Feedstock>
    
    var base: Base
    
    init(for base: Base) {
        self.base = base
        
        let predicate = NSPredicate(
            format: "%K.base == %@", #keyPath(Feedstock.ingredients_), base
        )
        _feedstocks = Feedstock.defaultFetchRequest(with: predicate)
    }
    
    
    var body: some View {
        List {
            
            if !feedstocks.isEmpty {
                ListRow(
                    feedstocks.first!
                )
            }
            
            GenericListSection("Feedstocks", _feedstocks) { feedstock in
                FeedstockView(feedstock: feedstock)
            }
            
            
            Section(header: Text("Total")) {
                LabelWithDetail("puzzlepiece", "Feedstock Cost", base.costExVAT.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Feedstock"),
                footer: Text("Sorted by Feedstock Qty")
            ) {
                ForEach(feedstocks, id: \.objectID) { feedstock in
                    NavigationLink(
                        destination: FeedstockView(feedstock: feedstock)
                    ) {
                        ListRow(feedstock)
                    }
                }
                .onDelete(perform: removeFeedstock)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: CreateOrphanButton<Feedstock>())
    }
    
    private func removeFeedstock(at offsets: IndexSet) {
        for index in offsets {
            let feedstockf = feedstocks[index]
            moc.delete(feedstockf)
        }
        moc.saveContext()
    }
}
