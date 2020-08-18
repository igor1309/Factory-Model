//
//  BuyerEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct BuyerEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let buyerToEdit: Buyer?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        buyerToEdit = nil
        
        _name = State(initialValue: "")
        _factory = State(initialValue: nil)
        
        title = "New Buyer"
    }
    
    init(buyer: Buyer) {
        _isPresented = .constant(true)
        
        buyerToEdit = buyer
        
        _name = State(initialValue: buyer.name)
        _factory = State(initialValue: buyer.factory)
        
        title = "Edit Buyer"
    }
    
    @State private var name: String
    @State private var factory: Factory?
    
    @State private var isSalesDraftActive = false
    @State private var salesDrafts = [SalesDraft]()
    
    var body: some View {
        NavigationLink(
            destination: CreateSales(salesDrafts: $salesDrafts),
            isActive: $isSalesDraftActive
        ) {
            EmptyView()
        }
        
        List {
            Section(
                header: Text(name.isEmpty ? "" : "Edit Buyer Name")
            ) {
                TextField("Buyer Name", text: $name)
            }
            
            EntityPickerSection(selection: $factory)
            
            Section(
                header: Text("Sales")
            ) {
                Button {
                    isSalesDraftActive = true
                } label: {
                    Label("Add Sales", systemImage: Sales.plusButtonIcon)
                }
                
                ForEach(salesDrafts) { item in
                    //  MARK: - FINISH THIS
                    //  make nice row, see ListRow for example
                    Text(item.title)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let buyer: Buyer
                    if let buyerToEdit = buyerToEdit {
                        buyer = buyerToEdit
                    } else {
                        buyer = Buyer(context: context)
                    }
                    
                    buyer.name = name
                    buyer.factory = factory
                    
                    for draft in salesDrafts {
                        let sales = Sales(context: context)
                        sales.priceExVAT = draft.priceExVAT
                        sales.qty = draft.qty
                        sales.product = draft.product
                        buyer.addToSales_(sales)
                    }
                    
                    
                    
                    context.saveContext()
                    
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(factory == nil || name.isEmpty)
            }
        }
    }
}

fileprivate struct SalesDraft: Identifiable {
    var priceExVAT: Double
    var qty: Double
    var product: Product?
    
    var id = UUID()
    var title: String {
        "\(product?.name ?? "") \(qty) \(priceExVAT)"
    }
}


fileprivate struct CreateSales: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var salesDrafts: [SalesDraft]
    
    @State private var priceExVAT: Double = 0
    @State private var qty: Double = 0
    @State private var product: Product?
    
    var body: some View {
        List {
            EntityPickerSection(selection: $product)
            
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
                            product: product
                        )
                    )
                    
                    presentation.wrappedValue.dismiss()
                }
                .disabled(priceExVAT == 0 || qty == 0 || product == nil)
            }
        }
    }
}
