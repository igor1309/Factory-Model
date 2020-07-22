//
//  FeedstockList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct FeedstockList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var feedstocks: FetchedResults<Feedstock>
    
    //    var factory: Factory
    //    let division: String
    let product: Product
    
    init(for product: Product) {
        self.product = product
        //        self.factory = factory
        //        self.division = division
        _feedstocks = FetchRequest(
            entity: Feedstock.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Feedstock.qty, ascending: false),
                NSSortDescriptor(keyPath: \Feedstock.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "product = %@", product
            )
        )
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                LabelWithDetail("Feedstock Cost", product.cost.formattedGroupedWith1Decimal)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Feedstock"),
                footer: Text("Sorted by Feedstock Qty")
            ) {
                ForEach(feedstocks, id: \.self) { feedstock in
                    NavigationLink(
                        destination: FeedstockView(feedstock: feedstock, for: product)
                    ) {
                        ListRow(
                            title: feedstock.name,
                            subtitle: "\(feedstock.qty) @ \(feedstock.price) = \(feedstock.total)",
                            icon: "puzzlepiece",
                            useSmallerFont: true
                        )
                    }
                }
                .onDelete(perform: removeFeedstock)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.name)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let feedstock = Feedstock(context: managedObjectContext)
            //feedstock.name = "New Feedstock"
            //feedstock.note = "Some note regarding new feedstock"
            //                    feedstock.division = division
            //feedstock.department = "..."
            //feedstock.position = "Worker"
            feedstock.name = " ..."
            product.addToFeedstock_(feedstock)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeFeedstock(at offsets: IndexSet) {
        for index in offsets {
            let feedstockf = feedstocks[index]
            managedObjectContext.delete(feedstockf)
        }
        
        managedObjectContext.saveContext()
    }
}

//struct FeedstockList_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedstockList()
//    }
//}
