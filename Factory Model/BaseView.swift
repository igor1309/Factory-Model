//
//  BaseView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.managedObjectContext) var сontext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var base: Base
    
    @FetchRequest private var products: FetchedResults<Product>
    
    init(_ base: Base) {
        self.base = base
        _products = FetchRequest(
            entity: Product.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Product.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "base = %@", base
            )
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Base")) {
                Group {
                    NavigationLink(
                        destination: BaseEditor(base)
                    ) {
                        Text(base.title)
                    }
                    
                    if base.closingInventory < 0 {
                        Text("Negative Closing Inventory - check Baseion and Sales Qty!")
                            .foregroundColor(.systemRed)
                    }
                    
                    LabelWithDetail("MARK: CHANGE IN PACKAGING AND PRODUCTION!!! Baseion Qty", "base.baseQty.formattedGrouped")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(header: Text("Cost")) {
                Group {
                    LabelWithDetail("Baseion Cost", base.costExVAT.formattedGrouped)
                    LabelWithDetail("Total Baseion Cost", base.totalCostExVAT.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                Group {
                    LabelWithDetail("bag", "Sales Qty", base.totalSalesQty.formattedGrouped)
                    
                    VStack(spacing: 4) {
                        LabelWithDetail("dollarsign.circle", "Avg price, ex VAT", base.avgPriceExVAT.formattedGroupedWith1Decimal)
                        
                        LabelWithDetail("dollarsign.circle", "Avg price, incl VAT", base.avgPriceWithVAT.formattedGroupedWith1Decimal)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    
                    LabelWithDetail("cart", "Sales, ex VAT", base.revenueExVAT.formattedGrouped)
                    
                    LabelWithDetail("wrench.and.screwdriver", "COGS", base.cogs.formattedGrouped)
                    
                    LabelWithDetail("rectangle.rightthird.inset.fill", "Margin****", base.margin.formattedGrouped)
                        .foregroundColor(.systemOrange)
                    
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Inventory")) {
                Group {
                    LabelWithDetail("building.2", "Initial Inventory", base.initialInventory.formattedGrouped)
                    
                    LabelWithDetail("building.2", "Closing Inventory", base.closingInventory.formattedGrouped)
                        .foregroundColor(base.closingInventory < 0 ? .systemRed : .primary)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            сontext.saveContext()
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView(Base())
    }
}
