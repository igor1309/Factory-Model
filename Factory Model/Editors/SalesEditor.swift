//
//  SalesEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct SalesEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let salesToEdit: Sales?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        salesToEdit = nil
        
        _priceExVAT = State(initialValue: 0)
        _qty = State(initialValue: 0)
        _buyer = State(initialValue: nil)
        _product = State(initialValue: nil)
        
        title = "New Sales"
    }
    
    init(_ sales: Sales) {
        _isPresented = .constant(true)
        
        salesToEdit = sales
        
        _priceExVAT = State(initialValue: sales.priceExVAT)
        _qty = State(initialValue: sales.qty)
        _buyer = State(initialValue: sales.buyer)
        _product = State(initialValue: sales.product)
        
        title = "Edit Sales"
    }
    
    @State private var priceExVAT: Double
    @State private var qty: Double
    @State private var buyer: Buyer?
    @State private var product: Product?

    var body: some View {
        List {
            EntityPickerSection(selection: $buyer)
            
            EntityPickerSection(selection: $product)
            
            AmountPicker(systemName: "square", title: "Product Qty", navigationTitle: "Qty", scale: .large, amount: $qty)
                .foregroundColor(qty <= 0 ? .systemRed : .accentColor)
            
            AmountPicker(systemName: "dollarsign.circle", title: "Price, ex VAT", navigationTitle: "Price", scale: .small, amount: $priceExVAT)
                .foregroundColor(priceExVAT <= 0 ? .systemRed : .accentColor)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let sales: Sales
                    if let salesToEdit = salesToEdit {
                        sales = salesToEdit
                    } else {
                        sales = Sales(context: context)
                    }
                    
                    sales.name = ""
                    sales.priceExVAT = priceExVAT
                    sales.qty = qty
                    sales.buyer = buyer
                    sales.product = product
                    
                    context.saveContext()
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(priceExVAT == 0 || qty == 0 || buyer == nil || product == nil)
            }
        }
    }
}
