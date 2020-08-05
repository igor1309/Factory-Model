//
//  UnitPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 03.08.2020.
//

import SwiftUI

struct UnitPicker: View {
    @Binding var unit_: String?
    
    @State private var showTable = false
    
    var body: some View {
        let unitString = Binding<String>(
            get: { unit_ ?? "??"},
            set: { unit_ = $0 }
        )
        
        Button(unitString.wrappedValue) {
            showTable = true
        }
        .font(.subheadline)
        .sheet(isPresented: $showTable) {
            UnitPickerTable(unitString: unitString)
        }
    }
}

fileprivate struct UnitPickerTable: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var unitString: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach([UnitMass.grams, UnitMass.kilograms, UnitVolume.liters], id: \.self) { mvUnit in
                    Button {
                        unitString = mvUnit.symbol
                        presentation.wrappedValue.dismiss()
                    } label: {
                        Text(mvUnit.symbol)
                            .foregroundColor(mvUnit.symbol == unitString ? .systemOrange : .accentColor)
                            .tag(mvUnit.symbol)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Unit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UnitPicker_Previews: PreviewProvider {
    @State static var unit_: String?
    
    static var previews: some View {
        UnitPicker(unit_: $unit_)
            .border(Color.white)
            .preferredColorScheme(.dark)
    }
}
