//
//  PackagingView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct PackagingView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var packaging: Packaging
    @ObservedObject var factory: Factory
    
    @State private var showPicker = false
    
    var body: some View {
        List {
            Section(
                header: Text("")
            ) {
                Group {
                    NavigationLink(
                        destination: PackagingEditor(packaging: packaging)
                    ) {
                        Text("Edit '\(packaging.detail ?? packaging.title)' Packaging")
                    }
                    .foregroundColor(.accentColor)
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Base")
            ) {
                BasePicker(base: $packaging.base, factory: factory)
            }
            
            Section(
                header: Text("")
            ) {
                LabelWithDetailView("Base Qty per Package", QtyPicker(qty: $packaging.baseQty))
                
                LabelWithDetail("TBD: Select Base", "TBD")
                
                NavigationLink(
                    destination: SalesList(for: packaging)
                ) {
                    Label("Edit Sales", systemImage: "cart")
                }
                .foregroundColor(.accentColor)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(packaging.title)
    }
}
