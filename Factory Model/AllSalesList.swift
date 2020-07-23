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
    
    @FetchRequest private var sales: FetchedResults<Sales>
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
        _sales = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.buyer_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Sales.product.factory), factory
            )
        )
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Total"),
                footer: Text("To edit Sales go to Product")
            ) {
                LabelWithDetail("cart", "Total revenue, ex VAT", factory.revenueExVAT.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                ForEach(sales, id: \.objectID) { sales in
                    
                    NavigationLink(
                        destination: SalesEditor(sales: sales)
                    ) {
                        SalesRow(sales)
                    }
                }
                .onDelete(perform: removeSales)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sales")
        .navigationBarItems(trailing: plusButton)
    }
    
    @State private var showProductPicker = false
    private var plusButton: some View {
        Button {
            //  MARK: FINISH THIS
            showProductPicker = true
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
        //        .sheet(isPresented: $showProductPicker, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
        //              ProductPicker(product: .constant(Product()), for: factory)
        //            BuyerPicker(buyer: .constant(Buyer()), factory: factory)
        //        }
    }
    
    private func removeSales(at offsets: IndexSet) {
        for index in offsets {
            let sale = sales[index]
            managedObjectContext.delete(sale)
        }
        
        managedObjectContext.saveContext()
    }
}

//struct AllSalesList_Previews: PreviewProvider {
//    static var previews: some View {
//        AllSalesList()
//    }
//}
