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
                    TextField("Group", text: $draft.group)
                    TextField("Code", text: $draft.code)
                    TextField("Name", text: $draft.name)
                    TextField("Note", text: $draft.note)
                    
                    LabelWithDetail("TBD: Weight Netto", draft.weightNetto.formattedGroupedWith1Decimal)
                    
                    LabelWithDetail("TBD: Packaging", draft.packagingCode)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
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
