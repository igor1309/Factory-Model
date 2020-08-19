//
//  NameSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import SwiftUI

struct NameSection<T: Managed & Monikerable>: View {
    @Binding var name: String
    
    var body: some View {
        Section(
            header: Text(name.isEmpty ? "" : "Edit \(T.entityName) Name")
        ) {
            TextField("\(T.entityName) Name", text: $name)
                .foregroundColor(.accentColor)
        }
    }
}
