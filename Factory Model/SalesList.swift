//
//  SalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct SalesList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var sales: FetchedResults<Sales>
    
//    @ObservedObject
    var product: Product
    
    init(for product: Product) {
        self.product = product
        _sales = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.priceExVAT, ascending: true)
            ],
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Sales.product), product
            )
        )
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                LabelWithDetail("creditcard", "Sales Total, ex VAT", product.revenueExVAT.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                ForEach(sales, id: \.objectID) { sales in
                    NavigationLink(
                        destination: SalesView(sales, for: product.base!.factory!)
                    ) {
                        ListRow(sales)
                    }
                }
                .onDelete(perform: removeSales)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.title)
        .navigationBarItems(trailing: plusButton)
    }
    
    //  MARK: - can't replace with PlusEntityButton: linked entities
    private var plusButton: some View {
        Button {
            let buyer = Buyer(context: moc)
            buyer.name = " John"

            let sales = Sales(context: moc)
            sales.qty = 1_000
            sales.priceExVAT = 300
            sales.buyer = buyer
            
            product.addToSales_(sales)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeSales(at offsets: IndexSet) {
        for index in offsets {
            let sale = sales[index]
            moc.delete(sale)
        }
        moc.saveContext()
    }
}
