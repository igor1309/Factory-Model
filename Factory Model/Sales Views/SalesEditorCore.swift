//
//  SalesEditorCore.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct SalesEditorCore: View {
    @ObservedObject var sales: Sales
    
    init(_ sales: Sales) {
        self.sales = sales
    }
    
   @ViewBuilder var footer: some View {
        if sales.isValid {
            Text("Can save!")
                .foregroundColor(.secondary)
        } else {
            Text("ERROR: Select all parameters.")
                .foregroundColor(.systemRed)
        }
    }
    
    var body: some View {
        Section(
            footer: footer
        ) {
            Group {
                Group {
                    //  MARK: - FINISH THIS FIND SOLUTION TO FETCH PRODUCTS FOR FACTORY
                    EntityPicker(selection: $sales.product, icon: "bag", predicate: nil)
                    
                    //  MARK: - FINISH THIS FIND SOLUTION TO FETCH BUYERS FOR FACTORY
                    EntityPicker(selection: $sales.buyer, icon: "cart", predicate: nil)
                    
                    AmountPicker(systemName: "bag", title: "Qty", navigationTitle: "Qty", scale: .large, amount: $sales.qty)
                    
                    AmountPicker(systemName: "dollarsign.circle", title: "Price ex VAT", navigationTitle: "Price", scale: .small, amount: $sales.priceExVAT)
                }
                .foregroundColor(.accentColor)
                
                
                LabelWithDetail("dollarsign.circle", "Price with VAT", sales.priceWithVAT.formattedGrouped)
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Total Sales")
        ) {
            Group {
                LabelWithDetail("creditcard", "Total Sales ex VAT", sales.revenueExVAT.formattedGrouped)
                
                LabelWithDetail("creditcard", "Total Sales with VAT", sales.revenueWithVAT.formattedGrouped)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}
