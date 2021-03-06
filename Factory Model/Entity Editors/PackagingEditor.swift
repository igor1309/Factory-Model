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
    
    @EnvironmentObject private var settings: Settings
    
    @Binding var isPresented: Bool
    
    let packagingToEdit: Packaging?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        packagingToEdit = nil
        
        _name = State(initialValue: "")
        _type = State(initialValue: "")
        
        title = "New Packaging"
    }
    
    init(_ packaging: Packaging) {
        _isPresented = .constant(true)
        
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
                        Text(packaging.productList(in: settings.period))
                            .foregroundColor(packaging.isValid ? .secondary : .systemRed)
                    }
                    .font(.caption)
                }
                
                //header: "Оставлять ли этот список?",
                GenericListSection(type: Product.self, predicate: NSPredicate(format: "%K == %@", #keyPath(Product.packaging), packaging))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let haptics = Haptics()
            haptics.feedback()
            
            withAnimation {
                let packaging: Packaging
                
                if let packagingToEdit = packagingToEdit {
                    packaging = packagingToEdit
                    packaging.objectWillChange.send()
                } else {
                    packaging = Packaging(context: context)
                }
                
                packaging.name = name
                packaging.type = type
                
                context.saveContext()
                
                isPresented = false
                presentation.wrappedValue.dismiss()
            }
        }
        .disabled(name.isEmpty)
    }
}

struct PackagingEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    PackagingEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 300))
            
            NavigationView {
                VStack {
                    PackagingEditor(Packaging.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 300))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
