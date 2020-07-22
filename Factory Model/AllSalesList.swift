//
//  AllSalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI
import SwiftPI

struct AllSalesList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var sales: FetchedResults<Sales>
    
    var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
        _sales = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.buyer_, ascending: true)
            ]
        )
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Sales"),
                footer: Text("To edit Sales go to Product")
            ) {
                LabelWithDetail("cart", "Total revenue, ex VAT", factory.revenueExVAT.formattedGrouped)
                .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                ForEach(factory.sales, id: \.self) { sales in
                    ListRow(
                        title: sales.buyer,
                        subtitle: sales.comment,
                        icon: "cart",
                        useSmallerFont: true
                    )
                }
                .onDelete(perform: removeSales)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sales")
    }
    
    private func removeSales(at offsets: IndexSet) {
        for index in offsets {
            let sale = sales[index]
            managedObjectContext.delete(sale)
        }
        
        managedObjectContext.saveContext()
        //        save()
    }
    
//    private func save() {
//        if self.managedObjectContext.hasChanges {
//            do {
//                try self.managedObjectContext.save()
//            } catch {
//                // handle the Core Data error
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
}

//struct AllSalesList_Previews: PreviewProvider {
//    static var previews: some View {
//        AllSalesList()
//    }
//}
