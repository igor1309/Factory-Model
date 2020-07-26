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
        _feedstocks = FetchRequest(
            entity: Feedstock.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Feedstock.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "ANY %K.base.factory == %@", #keyPath(Feedstock.ingredients_), factory
            )
        )
        _orphans = FetchRequest(
            entity: Feedstock.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Feedstock.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "ANY %K.base == nil", #keyPath(Feedstock.ingredients_)
            )
        )
        _allFeedstocks = FetchRequest(
            entity: Feedstock.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Feedstock.name_, ascending: true)
            ]
        )
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
            
            GenericSection("Feedstocks", _feedstocks) { feedstock in
                FeedstockView(feedstock: feedstock)
            }
            
            GenericSection("Orphans", _orphans) { feedstock in
                FeedstockView(feedstock: feedstock)
            }
            
            GenericSection("All Feedstocks @ all Factories", _allFeedstocks) { feedstock in
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
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let feedstock = Feedstock(context: moc)
            //feedstock.name = "New Feedstock"
            //feedstock.note = "Some note regarding new feedstock"
            //                    feedstock.division = division
            //feedstock.department = "..."
//            feedstock.position = "Worker"
            feedstock.name = " ..."
//            base.addToFeedstocks_(feedstock)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
