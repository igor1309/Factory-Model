//
//  SalesEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct SalesView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var sales: Sales
    
    init(_ sales: Sales) {
        self.sales = sales
    }
    
    var body: some View {
        List {
            SalesEditorCore(sales)
            
            //  parent check
            if sales.buyer == nil {
                EntityPicker(selection: $sales.buyer, icon: Buyer.icon)
                    .foregroundColor(.systemRed)
            }
            
            //  second parent check
            if sales.product == nil {
                EntityPicker(selection: $sales.product, icon: Product.icon)
                    .foregroundColor(.systemRed)
            }
            

            Section(header: Text("Sales")) {
                Text("TBD: MOVE SALES TO PRODUCT!!")
                    .foregroundColor(.systemRed)
                
                Group {
                    LabelWithDetail("square", "Sales Qty", "base.totalSalesQty")
                    
                    VStack(spacing: 4) {
                        LabelWithDetail("dollarsign.circle", "Avg price, ex VAT", "base.avgPriceExVAT")
                        
                        LabelWithDetail("dollarsign.circle", "Avg price, incl VAT", "base.avgPriceWithVAT")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    
                    LabelWithDetail("cart", "Sales, ex VAT", "base.revenueExVAT")
                    
                    LabelWithDetail("wrench.and.screwdriver", "COGS", "base.cogs")
                    
                    LabelWithDetail("rectangle.rightthird.inset.fill", "Margin****", "base.margin")
                        .foregroundColor(.systemOrange)
                    
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sales Editor")
        .navigationBarItems(
            trailing: Button("Save") {
                context.saveContext()
                presentation.wrappedValue.dismiss()
            }
        )
        .onDisappear {
            context.saveContext()
        }
    }
    
//    private var saveButton: some View {
//        Button("Save") {
//            moc.saveContext()
//            presentation.wrappedValue.dismiss()
//        }
//    }
}
