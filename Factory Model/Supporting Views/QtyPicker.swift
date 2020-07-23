//
//  QtyPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct QtyPicker: View {
    
    @Binding var qty: Double
    
    @State private var showTable = false
    
    var body: some View {
        Button("\(qty, specifier: "%.f")") {
            showTable = true
        }
//        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showTable) {
            QtyPickerTable(qty: $qty)
        }
    }
}

fileprivate struct QtyPickerTable: View {
    @Environment(\.presentationMode) var presentation
    
    let values: [Double] = [100, 200, 300, 500, 1_000, 1_500, 2_000, 2_500, 3_000, 5_000, 7_500, 10_000]
    
    @Binding var qty: Double
    
    var body: some View {
        NavigationView {
            List {
                ForEach(values, id: \.self) { value in
                    Button {
                        qty = value
                        presentation.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text(("\(value, specifier: "%.f")"))
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Qty")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct QtyPicker_Previews: PreviewProvider {
    @State static var qty = 3000.0
    
    static var previews: some View {
        QtyPicker(qty: $qty)
            .preferredColorScheme(.dark)
    }
}
