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
                NSSortDescriptor(keyPath: \Feedstock.qty, ascending: true),
                NSSortDescriptor(keyPath: \Feedstock.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "product = %@", product
            )
        )
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Feedstock Total Cost".uppercased())) {
                HStack {
                    Text("Feedstock Total Cost")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("TBD \(100, specifier: "%.f")")
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Feedstock".uppercased())) {
                ForEach(feedstocks, id: \.self) { feedstock in
                    NavigationLink(
                        destination: FeedstockView(feedstock: feedstock, for: product)
                    ) {
                        ListRow(title: feedstock.name,
                                subtitle: "\(feedstock.qty) @ TBD: price, TOTAL COST",
                                icon: "puzzlepiece")
                    }
                }
                .onDelete(perform: removeFeedstock)
                
                Button("Add Feedstock") {
                    let feedstock = Feedstock(context: managedObjectContext)
                    //feedstock.name = "New Feedstock"
                    //feedstock.note = "Some note regarding new feedstock"
                    //                    feedstock.division = division
                    //feedstock.department = "..."
                    //feedstock.position = "Worker"
                    feedstock.name = "John"
                    product.addToFeedstock_(feedstock)
                    save()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.name)
    }
    
    private func removeFeedstock(at offsets: IndexSet) {
        for index in offsets {
            let feedstockf = feedstocks[index]
            managedObjectContext.delete(feedstockf)
        }
        
        save()
    }
    
    private func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // handle the Core Data error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//struct FeedstockList_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedstockList()
//    }
//}
