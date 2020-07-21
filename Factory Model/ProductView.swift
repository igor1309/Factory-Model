//
//  ProductView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct ProductView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation

    var product: Product
    
    @FetchRequest var sales: FetchedResults<Sales>
    
    @State private var draft: Product
    
    init(_ product: Product) {
        self.product = product
        _draft = State(initialValue: product)
        _sales = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.buyer_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "product = %@", product
            )
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Product".uppercased())) {
                TextField("Group", text: $draft.group)
                TextField("Code", text: $draft.code)
                TextField("Name", text: $draft.name)
                TextField("Note", text: $draft.note)
                
                HStack {
                    Text("Weight Netto")
                    Spacer()
                    Text("\(draft.weightNetto, specifier: "%.1f")")
                }
                
                if draft.packaging != nil {
                    HStack {
                        Text("Packaging")
                        Spacer()
                        Text("\(draft.packaging!.code)")
                    }
                }
                
                HStack {
                    Text("Production Qty")
                    Spacer()
                    Text("\(draft.productionQty, specifier: "%.1f")")
                }
            }
            
            Section(header: Text("Sales".uppercased())) {
                ForEach(sales, id: \.self) { sale in
                    ListRow(title: sale.buyer, subtitle: "\(sale.qty) @ \(sale.price)", icon: "cart")
                }
                
                HStack {
                    Text("Total Sales")
                    Spacer()
                    Text("TBD")
                }
                .font(.subheadline)
                
                ForEach(product.sales, id: \.self) { sale in
                    ListRow(title: sale.buyer, subtitle: "\(sale.qty) @ \(sale.price)", icon: "cart")
                }
                

                Button("Add Sales") {
                    let sales = Sales(context: managedObjectContext)
                    product.addToSales_(sales)
                    save()
                }
            }
            
            Section(header: Text("Feedstock".uppercased())) {
                ForEach(product.feedstock, id: \.self) { feedstock in
                    NavigationLink(
                        destination: FeedstockView(feedstock: feedstock, for: product)
                    ) {
                        ListRow(title: feedstock.name, subtitle: "\(feedstock.qty) @ TBD: price, TOTAL COST", icon: "puzzlepiece")
                    }
                }
                
                HStack {
                    Text("Feedstock Total Cost")
                    Spacer()
                    Text("TBD")
                }
                .font(.subheadline)
                
                Button("Add Feedstock") {
                    let feedstock = Feedstock(context: managedObjectContext)
                    product.addToFeedstock_(feedstock)
                    save()
                }
            }
            
            Section(header: Text("Utilities".uppercased())) {
                ForEach(product.utilities, id: \.self) { utility in
                    ListRow(title: utility.name, subtitle: "\(utility.price)", icon: "lightbulb")
                }
                
                HStack {
                    Text("Total Utilities")
                    Spacer()
                    Text("TBD")
                }
                .font(.subheadline)
                
                Button("Add Utility") {
                    let utility = Utility(context: managedObjectContext)
                    product.addToUtilities_(utility)
                    save()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            //  MARK: FINISH THIS
            
            save()
            presentation.wrappedValue.dismiss()
        }
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

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(Product())
    }
}
