//
//  BaseEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct BaseEditor: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var base: Base

    init(_ base: Base) {
        self.base = base
    }
    
    var body: some View {
        List {
            Text("NEEDS TO BE COMPLETLY REDONE")
                .foregroundColor(.systemRed)
                .font(.headline)
            
            Section(header: Text("Base")) {
                Group {
                    TextField("Name", text: $base.name)
                    
                    if base.baseGroups.isEmpty {
                        HStack {
                            Text("Group")
                                .foregroundColor(.secondary)
                            TextField("Group", text: $base.group)
                                .foregroundColor(.accentColor)
                        }
                    } else {
                        PickerWithTextField(selection: $base.group, name: "Group", values: base.baseGroups)
                    }
                    
                    TextField("Code", text: $base.code)
                    TextField("Note", text: $base.note)
                    
                    AmountPicker(systemName: "scalemass", title: "Weight Netto", navigationTitle: "Weight", scale: .small, qty: $base.weightNetto)
                    
                    LabelWithDetail("TBD: List of Products using \(base.name)", base.productList)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(header: Text("Feedstock")) {
                NavigationLink(
                    destination: FeedstockList(for: base)
                ) {
                    LabelWithDetail("puzzlepiece", "Feedstock Cost ex VAT", base.costExVAT.formattedGrouped)
                        .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }
            
            Section(header: Text("Utilities")) {
                NavigationLink(
                    destination: UtilityList(for: base)
                ) {
                    LabelWithDetail("lightbulb", "Total Utilities", "TBD")
                        .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
//        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct BaseEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        BaseEditor()
//    }
//}
