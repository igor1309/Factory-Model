//
//  PackagingPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI
import CoreData

struct PackagingPicker: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var packaging: Packaging?
    
    var factory: Factory
    
    @State private var showPicker = false
    var body: some View {
        Button {
            showPicker = true
        } label: {
            Text(packaging?.title ?? "--")
        }
        .sheet(isPresented: $showPicker, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
            PackagingPickerTable(packaging: $packaging, for: factory, in: managedObjectContext)
        }
    }
}

fileprivate struct PackagingPickerTable: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var packaging: Packaging?
    var factory: Factory
    var context: NSManagedObjectContext
    
    init(packaging: Binding<Packaging?>, for factory: Factory, in context: NSManagedObjectContext) {
        _packaging = packaging
        self.factory = factory
        self.context = context
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(factory.packagingTypes, id: \.self) { type in
                    Section(
                        header: Text(type)
                    ) {
                        ForEach(factory.packagingForType(type), id: \.objectID) { packaging in
                            Button {
                                self.packaging = packaging
                                presentation.wrappedValue.dismiss()
                            } label: {
                                Text(packaging.title).tag(packaging)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Product")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
