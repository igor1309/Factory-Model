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
            Section(header: Text("Product")) {
                Group {
                    NavigationLink(
                        destination: ProductEditor(draft: $draft)
                    ) {
                        Text("\(draft.name)/\(draft.group)/\(draft.code)")
                    }
//                    TextField("Group", text: $draft.group)
//                    TextField("Code", text: $draft.code)
//                    TextField("Name", text: $draft.name)
//                    TextField("Note", text: $draft.note)
//
//                    HStack {
//                        Text("TBD: Weight Netto")
//                        Spacer()
//                        Text("\(draft.weightNetto, specifier: "%.1f")")
//                    }
//
//                    HStack {
//                        Text("TBD: Packaging")
//                        Spacer()
//                        if draft.packaging != nil {
//                            Text("\(draft.packaging!.code)")
//                        }
//                    }
                    
                    HStack {
                        Text("TBD: Production Qty")
                        Spacer()
                        Text("\(draft.productionQty, specifier: "%.1f")")
                    }
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
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
                            .padding(.trailing)
                    }
                    
                    VStack(spacing: 4) {
                        HStack {
                            Text("Avg price")
                            Spacer()
                            Text("\(draft.avgPriceExVAT, specifier: "%.1f")")
                                .padding(.trailing)
                        }
                        
                        HStack {
                            Text("Avg price, incl VAT")
                            Spacer()
                            Text("\(draft.avgPriceWithVAT, specifier: "%.1f")")
                                .padding(.trailing)
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
                    .foregroundColor(.accentColor)
                    
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
                        Label("Feedstock Cost", systemImage: "puzzlepiece")
                        Spacer()
                        Text("\(draft.cost, specifier: "%.1f")")
                    }
                    .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }
            
            Section(header: Text("Utilities".uppercased())) {
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
                .foregroundColor(.accentColor)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
//        .navigationBarItems(trailing: saveButton)
    }
    
//    private var saveButton: some View {
//        Button("Save") {
//            //  MARK: FINISH THIS
//            
//            save()
//            presentation.wrappedValue.dismiss()
//        }
//    }
    
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
