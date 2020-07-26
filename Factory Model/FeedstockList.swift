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
    
    //    var factory: Factory
    //    let division: String
//    @ObservedObject
    var base: Base
    
    init(for base: Base) {
        self.base = base
        //        self.factory = factory
        //        self.division = division
        _feedstocks = FetchRequest(
            entity: Feedstock.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Feedstock.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "%K.base == %@", #keyPath(Feedstock.ingredients_), base
            )
        )
    }
    
    
    var body: some View {
        List {
            
            if !feedstocks.isEmpty {
                ListRow(
                    feedstocks.first!
                )
            }
            
            GenericSection("Feedstocks", _feedstocks) { feedstock in
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
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let feedstock = Feedstock(context: moc)
            //feedstock.name = "New Feedstock"
            //feedstock.note = "Some note regarding new feedstock"
            //                    feedstock.division = division
            //feedstock.department = "..."
            //feedstock.position = "Worker"
            feedstock.name = " ..."
//            base.addToFeedstocks_(feedstock)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeFeedstock(at offsets: IndexSet) {
        for index in offsets {
            let feedstockf = feedstocks[index]
            moc.delete(feedstockf)
        }
        
        moc.saveContext()
    }
}
