//
//  ProductEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct ProductEditor: View {
    @Binding var draft: Product
    
    var body: some View {
        List {
            Section(header: Text("Product")) {
                Group {
                    TextField("Name", text: $draft.name)
                    TextField("Group", text: $draft.group)
                    TextField("Code", text: $draft.code)
                    TextField("Note", text: $draft.note)
                    
                    LabelWithDetail("TBD: Weight Netto", draft.weightNetto.formattedGroupedWith1Decimal)
                    
                    LabelWithDetail("TBD: Packaging", draft.packagingCode)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(header: Text("Feedstock")) {
                NavigationLink(
                    destination: FeedstockList(for: draft)
                ) {
                    LabelWithDetail("puzzlepiece", "Feedstock Cost", draft.cost.formattedGrouped)
                        .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }
            
            Section(header: Text("Utilities")) {
                NavigationLink(
                    destination: UtilityList(for: draft)
                ) {
                    LabelWithDetail("lightbulb", "Total Utilities", "TBD")
                        .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }

        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
    }
}

//struct ProductEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductEditor()
//    }
//}
