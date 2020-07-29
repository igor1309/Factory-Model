//
//  PickerWithTextField.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import SwiftUI

struct PickerWithTextField: View {
    @Binding var selection: String
    let name: String
    let values: [String]
    
    var body: some View {
        Picker(
            selection: $selection,
            label: HStack {
                Text(name)
                    .foregroundColor(.secondary)
                TextField(name, text: $selection)
                    .foregroundColor(.accentColor)
            }
        ) {
            ForEach(values, id: \.self) { text in
                Text(text)
            }
        }
    }
}

struct PickerWithTextField_Previews: PreviewProvider {
    @State static var text = "Some value"
    
    static var previews: some View {
        PickerWithTextField(selection: $text, name: "Value", values: [])
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
    }
}
