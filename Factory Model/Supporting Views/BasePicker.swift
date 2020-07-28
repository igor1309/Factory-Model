//
//  BasePicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI
import CoreData

struct BasePicker: View {
    @Environment(\.managedObjectContext) var moc
    
    @Binding var base: Base?
    
    var factory: Factory
    
    @State private var showPicker = false
    
    var body: some View {
        Button {
            showPicker = true
        } label: {
            if let base = base {
                Text(base.title)
            } else {
                Text("No Base")
                    .foregroundColor(.systemRed)
            }
        }
        .sheet(isPresented: $showPicker, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
            BasePickerTable(base: $base, for: factory)
                .environment(\.managedObjectContext, moc)
        }
    }
}

fileprivate struct BasePickerTable: View {
    @Environment(\.managedObjectContext) var moc
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
            .navigationBarItems(trailing: PlusButton(parent: factory, path: "bases_", keyPath: \Base.factory!))

        }
    }
}
