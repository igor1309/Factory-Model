//
//  PackagingEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct PackagingEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let packagingToEdit: Packaging?
    let title: String
    
    let period: Period
    
    init(isPresented: Binding<Bool>, in period: Period) {
        _isPresented = isPresented
        self.period = period
        
        packagingToEdit = nil
        
        _name = State(initialValue: "")
        _type = State(initialValue: "")
        
        title = "New Packaging"
    }
    
    init(_ packaging: Packaging, in period: Period) {
        _isPresented = .constant(true)
        self.period = period
        
        packagingToEdit = packaging
        
        _name = State(initialValue: packaging.name)
        _type = State(initialValue: packaging.type)
        
        title = "Edit Packaging"
    }
    
    @State private var name: String
    @State private var type: String
    
    var body: some View {
        List {
            NameSection<Packaging>(name: $name)
            
            PickerWithTextField(selection: $type, name: "Type", values: ["TBD"])
            
            if let packaging = packagingToEdit,
               !packaging.products.isEmpty {
                Section(
                    header: Text("Used in Products")
                ) {
                    Group {
                        Text(packaging.productList(in: period))
                            .foregroundColor(packaging.isValid ? .secondary : .systemRed)
                    }
                    .font(.caption)
                }
                
                GenericListSection(
                    //header: "Оставлять ли этот список?",
                    type: Product.self,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Product.packaging), packaging),
                    in: period
                ) { product in
                    ProductView(product, in: period)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let packaging: Packaging
            if let packagingToEdit = packagingToEdit {
                packaging = packagingToEdit
            } else {
                packaging = Packaging(context: context)
            }
            
            packaging.name = name
            packaging.type = type
            
            context.saveContext()
            
            isPresented = false
            presentation.wrappedValue.dismiss()
        }
        .disabled(name.isEmpty)
    }
}
