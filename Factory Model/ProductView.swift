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
            
            Section(header: Text("Cost".uppercased())) {
                Group {
                    HStack {
                        Text("Production Cost")
                        Spacer()
                        Text("\(draft.cost, specifier: "%.1f")")
                    }
                    HStack {
                        Text("Total Production Cost")
                        Spacer()
                        Text("\(draft.totalCost, specifier: "%.1f")")
                    }
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Sales".uppercased())) {
                Group {
                    HStack {
                        Text("Total Sales Qty")
                        Spacer()
                        Text("\(draft.totalSalesQty, specifier: "%.1f")")
                    }
                    
                    VStack(spacing: 4) {
                        HStack {
                            Text("Avg price")
                            Spacer()
                            Text("\(draft.avgPriceExVAT, specifier: "%.1f")")
                        }
                        
                        HStack {
                            Text("Avg price, incl VAT")
                            Spacer()
                            Text("\(draft.avgPriceWithVAT, specifier: "%.1f")")
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    
                    NavigationLink(
                        destination: SalesList(for: product)
                    ) {
                        HStack {
                            Label("Total Sales, ex VAT", systemImage: "cart")
                            Spacer()
                            Text("\(draft.revenueExVAT, specifier: "%.1f")")
                        }
                    }
                    
                    HStack {
                        Label("COGS", systemImage: "wrench.and.screwdriver")
                        Spacer()
                        Text("\(draft.cogs, specifier: "%.1f")")
                            .padding(.trailing)
                    }
                    
                    HStack {
                        Label("Margin****", systemImage: "rectangle.rightthird.inset.fill")
                        Spacer()
                        Text("\(draft.margin, specifier: "%.1f")")
                            .padding(.trailing)
                    }
                    .foregroundColor(.secondary)
                    
                }
                .font(.subheadline)
            }

            Section(header: Text("Inventory".uppercased())) {
                Group {
                    HStack {
                        Label("Initial Inventory", systemImage: "building.2")
                        Spacer()
                        Text("\(draft.initialInventory, specifier: "%.1f")")
                    }
                    
                    HStack {
                        Label("Closing Inventory", systemImage: "building.2")
                        Spacer()
                        Text("\(draft.closingInventory, specifier: "%.1f")")
                    }
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Feedstock".uppercased())) {
                NavigationLink(
                    destination: FeedstockList(for: product)
                ) {
                    HStack {
                        Label("Feedstock Total Cost", systemImage: "puzzlepiece")
                        Spacer()
                        Text("\(draft.cost, specifier: "%.1f")")
                    }
                    .font(.subheadline)
                }
            }
            
            Section(header: Text("Utilities".uppercased())) {
//                ForEach(product.utilities, id: \.self) { utility in
//                    ListRow(title: utility.name, subtitle: "\(utility.price)", icon: "lightbulb")
//                }
                
             NavigationLink(
                destination: UtilityList(for: product)
             ) {
                HStack {
                    Label("Total Utilities", systemImage: "lightbulb")
                    Spacer()
                    Text("TBD")
                }
                .font(.subheadline)
            }
//                Button("Add Utility") {
//                    let utility = Utility(context: managedObjectContext)
//                    product.addToUtilities_(utility)
//                    save()
//                }
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
