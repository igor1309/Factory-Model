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
    
    @EnvironmentObject private var settings: Settings
    
    @Binding var isPresented: Bool
    
    let buyerToEdit: Buyer?
    let title: String
    
    init(isPresented: Binding<Bool>, factory: Factory? = nil) {
        _isPresented = isPresented
        
        buyerToEdit = nil
        
        _name = State(initialValue: "")
        _factory = State(initialValue: factory)
        
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
    
    @State private var isNewDraftActive = false
    @State private var salesDrafts = [SalesDraft]()
    
    var body: some View {
        List {
            NameSection<Buyer>(name: $name)
            
            EntityPickerSection(selection: $factory, period: settings.period)
            
            DraftSection<Sales, SalesDraft>(isNewDraftActive: $isNewDraftActive, drafts: $salesDrafts)
            
            if let buyer = buyerToEdit,
               !buyer.sales.isEmpty {
                GenericListSection(header: "Existing Sales", type: Sales.self, predicate: NSPredicate(format: "%K == %@", #keyPath(Sales.buyer), buyer))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
        
        NavigationLink(
            destination: CreateSales(salesDrafts: $salesDrafts, kind: .forBuyer),
            isActive: $isNewDraftActive
        ) {
            EmptyView()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            let haptics = Haptics()
            haptics.feedback()
            
            withAnimation {
                let buyer: Buyer
                
                if let buyerToEdit = buyerToEdit {
                    buyer = buyerToEdit
                    buyer.objectWillChange.send()
                } else {
                    buyer = Buyer(context: context)
                }
                
                buyer.factory?.objectWillChange.send()
                
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
        }
        .disabled(factory == nil || name.isEmpty)
    }
}

struct BuyerEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    BuyerEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 400))
            
            NavigationView {
                VStack {
                    BuyerEditor(Buyer.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 550))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
