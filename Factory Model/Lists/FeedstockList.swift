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
//    @FetchRequest private var ingredients: FetchedResults<Ingredient>

    @ObservedObject var base: Base
    
    init(for base: Base) {
        self.base = base
        
        let predicate = NSPredicate(
            format: "ANY %K.base == %@", #keyPath(Feedstock.ingredients_), base
        )
        _feedstocks = Feedstock.defaultFetchRequest(with: predicate)
        
//        let ingredientPredicate = NSPredicate(
//            format: "ANY %K == %@", #keyPath(Base.ingredients_), base
//        )
//        _ingredients = Ingredient.defaultFetchRequest(with: ingredientPredicate)
    }
    
    
    var body: some View {
        EntityListWithDashboard(
            for: base,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Ingredient.feedstock), base
            ),
            keyPathParentToChildren: \Base.ingredients_
        ) {
            GenericListSection(fetchRequest: _feedstocks) { feedstock in
                FeedstockView(feedstock)
            }
            
            GenericListSection(fetchRequest: _feedstocks) { feedstock in
                FeedstockView(feedstock)
            }
            
            
            Section(header: Text("Total")) {
                LabelWithDetail("puzzlepiece", "Feedstock Cost", base.ingredientsCostExVAT.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }

        } editor: { (feedstock: Feedstock) in
            FeedstockView(feedstock)
        }

    }
        var old: some View {
        List {
            
            if !feedstocks.isEmpty {
                EntityRow(feedstocks.first!)
            }
            
            GenericListSection(fetchRequest: _feedstocks) { feedstock in
                FeedstockView(feedstock)
            }
            
            GenericListSection(fetchRequest: _feedstocks) { feedstock in
                FeedstockView(feedstock)
            }
            
            
            Section(header: Text("Total")) {
                LabelWithDetail("puzzlepiece", "Feedstock Cost", base.ingredientsCostExVAT.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Feedstock"),
                footer: Text("Sorted by Feedstock Qty")
            ) {
                ForEach(feedstocks, id: \.objectID) { feedstock in
                    NavigationLink(
                        destination: FeedstockView(feedstock)
                    ) {
                        EntityRow(feedstock)
                    }
                }
                .onDelete(perform: removeFeedstock)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
//        .navigationBarItems(trailing: CreateOrphanButton<Feedstock>())
//        .navigationBarItems(trailing: CreateChildButton(systemName: "plus.circle", childType: Feedstock.self, parent: base, keyPath: \Base.ingredients_.feedstock))
        //  MARK: - FINISH THIS USE THIS COFE FOR INGREDIENTS LIST
        //        .navigationBarItems(trailing: CreateChildButton(systemName: "plus.circle", childType: Ingredient.self, parent: base, keyPath: \Base.ingredients_))
    }
    
    private func removeFeedstock(at offsets: IndexSet) {
        for index in offsets {
            let feedstockf = feedstocks[index]
            moc.delete(feedstockf)
        }
        moc.saveContext()
    }
}
