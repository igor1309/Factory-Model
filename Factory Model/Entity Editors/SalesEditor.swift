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
        _qty =        State(initialValue: 0)
        _period =     State(initialValue: Period.month())
        _buyer =      State(initialValue: nil)
        _product =    State(initialValue: nil)
        
        title = "New Sales"
    }
    
    init(_ sales: Sales) {
        _isPresented = .constant(true)
        
        salesToEdit = sales
        
        _priceExVAT = State(initialValue: sales.priceExVAT)
        _qty =        State(initialValue: sales.qty)
        _period =     State(initialValue: sales.period)
        _buyer =      State(initialValue: sales.buyer)
        _product =    State(initialValue: sales.product)
        
        title = "Edit Sales"
    }
    
    @State private var priceExVAT: Double
    @State private var qty: Double
    @State private var period: Period
    @State private var buyer: Buyer?
    @State private var product: Product?

    var body: some View {
        List {
            EntityPickerSection(selection: $buyer, period: period)
            
            EntityPickerSection(selection: $product, period: period)
            
            PeriodPicker(icon: "deskclock", title: "Period", period: $period)
            
            AmountPicker(systemName: "square", title: "Product Qty", navigationTitle: "Qty", scale: .large, amount: $qty)
                .foregroundColor(qty <= 0 ? .systemRed : .accentColor)
            
            AmountPicker(systemName: "dollarsign.circle", title: "Price, ex VAT", navigationTitle: "Price", scale: .small, amount: $priceExVAT)
                .foregroundColor(priceExVAT <= 0 ? .systemRed : .accentColor)
            
            Section(
                header: Text("Total Sales")
            ) {
                LabelWithDetail(Sales.icon, "Sales, ex VAT", (qty * priceExVAT).formattedGrouped)                    
                .foregroundColor(.secondary)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            var sales: Sales
            if let salesToEdit = salesToEdit {
                sales = salesToEdit
                sales.objectWillChange.send()
            } else {
                sales = Sales(context: context)
            }
            
            sales.name = ""
            sales.priceExVAT = priceExVAT
            sales.qty = qty
            sales.period = period
            sales.buyer = buyer
            sales.product = product
            
            context.saveContext()
            
            isPresented = false
            presentation.wrappedValue.dismiss()
        }
        .disabled(priceExVAT == 0 || qty == 0 || buyer == nil || product == nil)
    }
}

struct SalesEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    SalesEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 600))
            
            NavigationView {
                VStack {
                    SalesEditor(Sales.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 600))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
