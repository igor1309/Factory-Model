//
//  PackagingCreator.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct PackagingCreator: View {
    @Environment(\.managedObjectContext) private var context
    
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var type: String = ""
    
    var body: some View {
        List {
            PackagingEditor(name: $name, type: $type)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(name.isEmpty ? "New Packaging" : name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let packaging = Packaging(context: context)
                    packaging.name = name
                    packaging.type = type
                    
                    context.saveContext()
                    isPresented = false
                }
                .disabled(name.isEmpty)
            }
        }
    }
}
