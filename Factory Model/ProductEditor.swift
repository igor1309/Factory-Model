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
                    
                    HStack {
                        Text("TBD: Weight Netto")
                        Spacer()
                        Text("\(draft.weightNetto, specifier: "%.1f")")
                    }
                    
                    HStack {
                        Text("TBD: Packaging")
                        Spacer()
                        if draft.packaging != nil {
                            Text("\(draft.packaging!.code)")
                        }
                    }
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
