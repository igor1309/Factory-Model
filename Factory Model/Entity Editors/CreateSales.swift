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
    @State private var period: Period = .month()
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
                    EntityPickerSection(selection: $buyer, period: period)
                case .forBuyer:
                    EntityPickerSection(selection: $product, period: period)
            }
            
            PeriodPicker(icon: "deskclock", title: "Period", period: $period)
            
            AmountPicker(systemName: "square", title: "Product Qty", navigationTitle: "Qty", scale: .large, amount: $qty)
                .foregroundColor(qty <= 0 ? .systemRed : .accentColor)
            
            AmountPicker(systemName: "dollarsign.circle", title: "Price, ex VAT", navigationTitle: "Price", scale: .small, amount: $priceExVAT)
                .foregroundColor(priceExVAT <= 0 ? .systemRed : .accentColor)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Add Sales")
        .navigationBarItems(trailing: doneButton)
    }
    
    private var doneButton: some View {
        Button("Done") {
            salesDrafts.append(
                SalesDraft(
                    priceExVAT: priceExVAT,
                    qty: qty,
                    period: period,
                    buyer: buyer,
                    product: product
                )
            )
            
            presentation.wrappedValue.dismiss()
        }
        .disabled(priceExVAT == 0 || qty == 0 || checkBuyerOrProduct)
    }
}

struct CreateSales_Previews: PreviewProvider {
    @State static var salesDrafts = [SalesDraft(priceExVAT: 123, qty: 321, period: .month(), buyer: Buyer.example, product: nil)]
    
    static var previews: some View {
        Group {
            NavigationView {
                CreateSales(salesDrafts: $salesDrafts, kind: .forBuyer)
            }
            NavigationView {
                CreateSales(salesDrafts: $salesDrafts, kind: .forProduct)
            }
        }
        .preferredColorScheme(.dark)
    }
}
