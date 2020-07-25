//
//  PackagingEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct PackagingEditor: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var packaging: Packaging
    
    var body: some View {
        List {
            Section(
                header: Text("Packaging Details")
            ) {
                Group {
                    HStack {
                        Text("name".capitalized)
                            .foregroundColor(.secondary)
                        TextField("name", text: $packaging.name)
                            .foregroundColor(.accentColor)
                    }
                    HStack {
                        Text("type".capitalized)
                            .foregroundColor(.secondary)
                        TextField("type", text: $packaging.type)
                            .foregroundColor(.accentColor)
                    }
                    HStack {
                        Text("code".capitalized)
                            .foregroundColor(.secondary)
                        TextField("code", text: $packaging.code)
                            .foregroundColor(.accentColor)
                    }
                    HStack {
                        Text("note".capitalized)
                            .foregroundColor(.secondary)
                        TextField("note", text: $packaging.note)
                            .foregroundColor(.accentColor)
                    }
                }
                .font(.subheadline)
                
                Group {
                    LabelWithDetail("title", packaging.title)
                    LabelWithDetail("subtitle", packaging.subtitle)
                    LabelWithDetail("detail", packaging.detail ?? "")
                }
                .foregroundColor(.secondary)
                .font(.footnote)
            }
            
            Section(
                header: Text("")
            ) {
                Group {
                    LabelWithDetail("baseQty", packaging.baseQty.formattedGrouped)
                        .foregroundColor(.accentColor)
                    LabelWithDetail("VAT", packaging.vat.formattedPercentage)
                        .foregroundColor(.accentColor)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(packaging.title)
    }
}
