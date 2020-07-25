//
//  SalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct SalesList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest private var sales: FetchedResults<Sales>
    
//    @ObservedObject
    var packaging: Packaging
    
    init(for packaging: Packaging) {
        self.packaging = packaging
        _sales = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.buyer_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "packaging = %@", packaging
            )
        )
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                LabelWithDetail("Sales Total, ex VAT", packaging.revenueExVAT.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                ForEach(sales, id: \.objectID) { sales in
                    NavigationLink(
                        destination: SalesView(sales, for: packaging.factory!)
                    ) {
                        ListRow(sales)
                    }
                }
                .onDelete(perform: removeSales)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(packaging.name)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let sales = Sales(context: managedObjectContext)
            sales.buyer = "John"
            sales.qty = 1_000
            sales.priceExVAT = 300
            packaging.addToSales_(sales)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeSales(at offsets: IndexSet) {
        for index in offsets {
            let sale = sales[index]
            managedObjectContext.delete(sale)
        }
        
        managedObjectContext.saveContext()
    }
}

//struct SalesList_Previews: PreviewProvider {
//    static var previews: some View {
//        SalesList()
//    }
//}
