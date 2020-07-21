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
            Section(header: Text("Sales Total".uppercased())) {
                
                HStack {
                    Text("Sales Total")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("TBD\(100, specifier: "%.f")")
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Sales".uppercased())) {
                ForEach(sales, id: \.self) { sales in
                    NavigationLink(
                        destination: SalesView(sales)
                    ) {
                        ListRow(title: sales.buyer,
                                subtitle: "\(sales.qty)",
                                icon: "puzzlepiece")
                    }
                }
                .onDelete(perform: removeSales)
                
                Button("Add Sales") {
                    let sales = Sales(context: managedObjectContext)
                    //sales.name = "New Sales"
                    //sales.note = "Some note regarding new sales"
                    //                    sales.division = division
                    //sales.department = "..."
                    //sales.position = "Worker"
                    sales.buyer = "John"
                    product.addToSales_(sales)
                    save()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.name)
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

//struct SalesList_Previews: PreviewProvider {
//    static var previews: some View {
//        SalesList()
//    }
//}
