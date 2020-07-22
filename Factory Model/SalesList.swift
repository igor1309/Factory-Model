//
//  SalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct SalesList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var sales: FetchedResults<Sales>
    
    let product: Product
    
    init(for product: Product) {
        self.product = product
        _sales = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.buyer_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "product = %@", product
            )
        )
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Sales Total, ex VAT")) {
                LabelWithDetail("Sales Total", product.revenueExVAT.formattedGroupedWith1Decimal)
                    .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                ForEach(sales, id: \.self) { sales in
                    NavigationLink(
                        destination: SalesView(sales)
                    ) {
                        ListRow(
                            title: sales.buyer,
                            subtitle: "\(sales.qty)",
                            icon: "cart"
                        )
                    }
                }
                .onDelete(perform: removeSales)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.name)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let sales = Sales(context: managedObjectContext)
            sales.buyer = "John"
            sales.qty = 1_000
            sales.price = 300
            product.addToSales_(sales)
            managedObjectContext.saveContext()
            //        save()
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

//struct SalesList_Previews: PreviewProvider {
//    static var previews: some View {
//        SalesList()
//    }
//}
