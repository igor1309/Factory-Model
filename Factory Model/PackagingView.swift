//
//  PackagingView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingView: View {
    @Environment(\.managedObjectContext) var moc
        
    @ObservedObject var packaging: Packaging
    
    var body: some View {
        List {
            ListRow(packaging)
            
            Section(
                header: Text("Packaging Details")
            ) {
                Group {
                    HStack {
                        Text("Name")
                            .foregroundColor(.secondary)
                        TextField("Name", text: $packaging.name)
                    }
                    
                    PickerWithTextField(selection: $packaging.type, name: "Type", values: ["TBD"])
                    
                }
                .font(.subheadline)
                .foregroundColor(.accentColor)
            }
            
            Section(
                header: Text("Products")
            ) {
                Group {
                    Text(packaging.productList)
                        .foregroundColor(packaging.isValid ? .primary : .systemRed)
                }
                .font(.subheadline)
            }
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(packaging.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
