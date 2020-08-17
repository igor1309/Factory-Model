//
//  ParentUnitStringPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct ParentUnitStringPicker: View {
    @Binding var unitString: String
    
    @State private var showTable = false
    
    var body: some View {
        Button {
            showTable = true
        } label: {
            Text(unitString.isEmpty ? "??" : unitString)
                .foregroundColor(unitString.isEmpty ? .systemRed : .accentColor)
        }
        .sheet(isPresented: $showTable) {
            UnitStringPickerTable(unitString: $unitString)
        }
    }
}

fileprivate struct UnitStringPickerTable: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var unitString: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(CustomUnit.allCases, id: \.self) { unit in
                    Button(unit.rawValue) {
                        unitString = unit.rawValue
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Unit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
