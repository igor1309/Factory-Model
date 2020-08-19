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
    
    init(_ buyer: Buyer) {
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
            destination: CreateSales(salesDrafts: $salesDrafts, kind: .forBuyer),
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
                header: Text("New Sales")
            ) {
                Button {
                    isSalesDraftActive = true
                } label: {
                    Label("Add Sales", systemImage: Sales.plusButtonIcon)
                }
                
                ForEach(salesDrafts) { item in
                    //  MARK: - FINISH THIS
                    //  make nice row, see ListRow for example
                    ListRow(item)
                }
            }
            
            if let buyer = buyerToEdit {
                GenericListSection(
                    header: "Existing Sales",
                    type: Sales.self,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Sales.buyer), buyer)
                ) { (sales: Sales) in
                    SalesEditor(sales)
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
