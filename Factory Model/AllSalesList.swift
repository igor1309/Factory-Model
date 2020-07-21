//
//  AllSalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

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
                HStack {
                    Label("Total revenue, ex VAT", systemImage: "cart")
                    Spacer()
                    Text("\(factory.revenueExVAT, specifier: "%.f")")
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Sales".uppercased())) {
                ForEach(factory.sales, id: \.self) { sales in
                    ListRow(title: sales.buyer,
                            subtitle: "\(sales.product == nil ? "" : sales.product!.name)",
                            detail: "\(sales.qty) @ \(sales.price)",
                            icon: "cart")
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

//struct AllSalesList_Previews: PreviewProvider {
//    static var previews: some View {
//        AllSalesList()
//    }
//}
