//
//  SalesEditorCore.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct SalesEditorCore: View {
    @ObservedObject var sales: Sales
    
    //  MARK: - FINISH THIS
    let period = Period.month()
    
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
        //  MARK: - FINISH THIS FIND SOLUTION TO FETCH BUYERS FOR FACTORY
        EntityPickerSection(selection: $sales.buyer, period: period)

        Section(
            header: Text("Product, Price")
        ) {
            Group {
                Group {
                    //  MARK: - FINISH THIS FIND SOLUTION TO FETCH PRODUCTS FOR FACTORY
                    EntityPicker(selection: $sales.product, icon: Product.icon, predicate: nil, period: period)
                        .foregroundColor(sales.product == nil ? .systemRed : .accentColor)

                    //  MARK: - FINISH THIS
                    //PeriodPicker(icon: "deskclock", title: "Period", period: $sales.period)

                    AmountPicker(systemName: "square", title: "Product Qty", navigationTitle: "Qty", scale: .large, amount: $sales.qty)
                        .foregroundColor(sales.qty <= 0 ? .systemRed : .accentColor)

                    AmountPicker(systemName: "dollarsign.circle", title: "Price, ex VAT", navigationTitle: "Price", scale: .small, amount: $sales.priceExVAT)
                        .foregroundColor(sales.priceExVAT <= 0 ? .systemRed : .accentColor)
                }
                .foregroundColor(.accentColor)
                
                
                LabelWithDetail("dollarsign.circle", "Price, with VAT", sales.priceWithVAT.formattedGrouped)
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
        }

        ErrorMessage(sales)
        
        Section(
            header: Text("Total Sales")
        ) {
            Group {
                LabelWithDetail("creditcard", "Sales, ex VAT", sales.revenueExVAT(in: period).formattedGrouped)
                
                LabelWithDetail("creditcard", "Sales, with VAT", sales.revenueWithVAT(in: period).formattedGrouped)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}
