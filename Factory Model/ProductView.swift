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
                    
                    if draft.closingInventory < 0 {
                        Text("Negative Closing Inventory - check Production and Sales Qty!")
                            .foregroundColor(.red)
                    }
                    
                    LabelWithDetailView("Production Qty", QtyPicker(qty: $draft.productionQty))
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(header: Text("Cost")) {
                Group {
                    LabelWithDetail("Production Cost", draft.cost.formattedGroupedWith1Decimal)
                    LabelWithDetail("Total Production Cost", draft.totalCost.formattedGroupedWith1Decimal)
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                Group {
                    LabelWithDetail("Total Sales Qty", draft.totalSalesQty.formattedGroupedWith1Decimal)
                            .padding(.trailing)
                    
                    VStack(spacing: 4) {
                        LabelWithDetail("Avg price", draft.avgPriceExVAT.formattedGroupedWith1Decimal)
                                .padding(.trailing)
                        
                        LabelWithDetail("Avg price, incl VAT", draft.avgPriceWithVAT.formattedGroupedWith1Decimal)
                                .padding(.trailing)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    
                    NavigationLink(
                        destination: SalesList(for: product)
                    ) {
                        LabelWithDetail("cart", "Total Sales, ex VAT", draft.revenueExVAT.formattedGrouped)
                    }
                    .foregroundColor(.accentColor)
                    
                    LabelWithDetail("wrench.and.screwdriver", "COGS", draft.cogs.formattedGroupedWith1Decimal)
                        .padding(.trailing)
                    
                    LabelWithDetail("rectangle.rightthird.inset.fill", "Margin****", draft.margin.formattedGrouped)
                        .padding(.trailing)
                        
                        .foregroundColor(.secondary)
                    
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Inventory")) {
                Group {
                    LabelWithDetail("building.2", "Initial Inventory", draft.initialInventory.formattedGroupedWith1Decimal)
                    
                    LabelWithDetail("building.2", "Closing Inventory", draft.closingInventory.formattedGroupedWith1Decimal)
                    .foregroundColor(draft.closingInventory < 0 ? .red : .primary)
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Feedstock")) {
                NavigationLink(
                    destination: FeedstockList(for: product)
                ) {
                    LabelWithDetail("puzzlepiece", "Feedstock Cost", draft.cost.formattedGroupedWith1Decimal)
                    .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }
            
            Section(header: Text("Utilities")) {
                NavigationLink(
                    destination: UtilityList(for: product)
                ) {
                    LabelWithDetail("lightbulb", "Total Utilities", "TBD")
                    .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            //  MARK: FINISH THIS

            managedObjectContext.saveContext()
            //        save()
//            presentation.wrappedValue.dismiss()
        }
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

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(Product())
    }
}
