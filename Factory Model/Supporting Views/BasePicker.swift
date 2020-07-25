//
//  BasePicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI
import CoreData

struct BasePicker: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var base: Base?
    
    var factory: Factory
    
    @State private var showPicker = false
    
    var body: some View {
        Button {
            showPicker = true
        } label: {
            if base == nil {
                Text("No Base")
                    .foregroundColor(.systemRed)
            } else {
                Text(base!.title)
            }
        }
        .sheet(isPresented: $showPicker, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
            BasePickerTable(base: $base, for: factory)
                .environment(\.managedObjectContext, managedObjectContext)
        }
    }
}

fileprivate struct BasePickerTable: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @Binding var base: Base?
    var factory: Factory
    
    init(base: Binding<Base?>, for factory: Factory) {
        _base = base
        self.factory = factory
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(factory.baseGroups, id: \.self) { group in
                    Section(
                        header: Text(group)
                    ) {
                        ForEach(factory.basesForGroup(group), id: \.objectID) { base in
                            Button {
                                self.base = base
                                presentation.wrappedValue.dismiss()
                            } label: {
                                Text(base.title).tag(base)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Base")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: plusButton)
        }
    }
    
    private var plusButton: some View {
        Button {
            let base = Base(context: managedObjectContext)
            base.name = "New Base"
            factory.addToBases_(base)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
