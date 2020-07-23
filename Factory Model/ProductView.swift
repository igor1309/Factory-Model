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
                    LabelWithDetail("Production Cost", draft.cost.formattedGrouped)
                    LabelWithDetail("Total Production Cost", draft.totalCost.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                Group {
                    LabelWithDetail("Total Sales Qty", draft.totalSalesQty.formattedGrouped)
                    
                    VStack(spacing: 4) {
                        LabelWithDetail("Avg price", draft.avgPriceExVAT.formattedGroupedWith1Decimal)
                        
                        LabelWithDetail("Avg price, incl VAT", draft.avgPriceWithVAT.formattedGroupedWith1Decimal)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    
                    LabelWithDetail("cart", "Total Sales, ex VAT", draft.revenueExVAT.formattedGrouped)
                    
                    LabelWithDetail("wrench.and.screwdriver", "COGS", draft.cogs.formattedGrouped)
                    
                    LabelWithDetail("rectangle.rightthird.inset.fill", "Margin****", draft.margin.formattedGrouped)
                        .foregroundColor(.systemOrange)
                    
                    NavigationLink(
                        destination: SalesList(for: product)
                    ) {
                        Label("Edit Sales", systemImage: "cart")
                    }
                    .foregroundColor(.accentColor)
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Inventory")) {
                Group {
                    LabelWithDetail("building.2", "Initial Inventory", draft.initialInventory.formattedGrouped)
                    
                    LabelWithDetail("building.2", "Closing Inventory", draft.closingInventory.formattedGrouped)
                        .foregroundColor(draft.closingInventory < 0 ? .red : .primary)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            managedObjectContext.saveContext()
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(Product())
    }
}
