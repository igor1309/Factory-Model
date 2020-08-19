//
//  CreateSales.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import SwiftUI

struct CreateSales: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var salesDrafts: [SalesDraft]
    
    enum Kind { case forProduct, forBuyer }
    
    let kind: Kind
    
    @State private var priceExVAT: Double = 0
    @State private var qty: Double = 0
    @State private var buyer: Buyer?
    @State private var product: Product?
    
    private var checkBuyerOrProduct: Bool {
        switch kind {
            case .forProduct:
                return buyer == nil
            case .forBuyer:
                return product == nil
        }
    }
    
    var body: some View {
        List {
            switch kind {
                case .forProduct:
                    EntityPickerSection(selection: $buyer)
                case .forBuyer:
                    EntityPickerSection(selection: $product)
            }
            
            AmountPicker(systemName: "square", title: "Product Qty", navigationTitle: "Qty", scale: .large, amount: $qty)
                .foregroundColor(qty <= 0 ? .systemRed : .accentColor)
            
            AmountPicker(systemName: "dollarsign.circle", title: "Price, ex VAT", navigationTitle: "Price", scale: .small, amount: $priceExVAT)
                .foregroundColor(priceExVAT <= 0 ? .systemRed : .accentColor)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Add Sales")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    salesDrafts.append(
                        SalesDraft(
                            priceExVAT: priceExVAT,
                            qty: qty,
                            buyer: buyer,
                            product: product
                        )
                    )
                    
                    presentation.wrappedValue.dismiss()
                }
                .disabled(priceExVAT == 0 || qty == 0 || checkBuyerOrProduct)
            }
        }
    }
}
