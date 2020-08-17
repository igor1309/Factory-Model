//
//  PackagingEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct PackagingEditor: View {
    @Binding var name: String
    @Binding var type: String
    
    var body: some View {
        Section(
            header: Text(name.isEmpty ? "" : "Edit Packaging Name")
        ) {
            TextField("Packaging Name", text: $name)
        }
        
        PickerWithTextField(selection: $type, name: "Type", values: ["TBD"])
    }
}
