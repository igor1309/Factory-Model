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
    
    @ObservedObject var product: Product
    
    @FetchRequest private var sales: FetchedResults<Sales>
    
    init(_ product: Product) {
        self.product = product
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
                        destination: ProductEditor(product)
                    ) {
                        Text(product.idd)
                    }
                    
                    if product.closingInventory < 0 {
                        Text("Negative Closing Inventory - check Production and Sales Qty!")
                            .foregroundColor(.red)
                    }
                    
                    LabelWithDetailView("Production Qty", QtyPicker(qty: $product.productionQty))
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(header: Text("Cost")) {
                Group {
                    LabelWithDetail("Production Cost", product.cost.formattedGrouped)
                    LabelWithDetail("Total Production Cost", product.totalCost.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                Group {
                    LabelWithDetail("bag", "Sales Qty", product.totalSalesQty.formattedGrouped)
                    
                    VStack(spacing: 4) {
                        LabelWithDetail("dollarsign.circle", "Avg price, ex VAT", product.avgPriceExVAT.formattedGroupedWith1Decimal)
                        
                        LabelWithDetail("dollarsign.circle", "Avg price, incl VAT", product.avgPriceWithVAT.formattedGroupedWith1Decimal)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    
                    LabelWithDetail("cart", "Sales, ex VAT", product.revenueExVAT.formattedGrouped)
                    
                    LabelWithDetail("wrench.and.screwdriver", "COGS", product.cogs.formattedGrouped)
                    
                    LabelWithDetail("rectangle.rightthird.inset.fill", "Margin****", product.margin.formattedGrouped)
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
                    LabelWithDetail("building.2", "Initial Inventory", product.initialInventory.formattedGrouped)
                    
                    LabelWithDetail("building.2", "Closing Inventory", product.closingInventory.formattedGrouped)
                        .foregroundColor(product.closingInventory < 0 ? .red : .primary)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.name)
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
