//
//  ChildUnitStringPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct ChildUnitStringPicker: View {
    @Binding var coefficientToParentUnit: Double
    
    let parentUnit: CustomUnit?
    
    @State private var showTable = false
    
    var buttonTitle: String {
        guard let parentUnit = parentUnit else {
            return "???"
        }
        
        return CustomUnit.unit(from: parentUnit, with: coefficientToParentUnit).rawValue
    }
    
    var body: some View {
        Button(buttonTitle) {
            showTable = true
        }
//        .foregroundColor(unitString.isEmpty ? .systemRed : .accentColor)
        .sheet(isPresented: $showTable) {
            ChildUnitStringPickerTable(coefficientToParentUnit: $coefficientToParentUnit, parentUnit: parentUnit)
        }
    }
}

fileprivate struct ChildUnitStringPickerTable: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var coefficientToParentUnit: Double
    
    let parentUnit: CustomUnit?
    
    var body: some View {
        NavigationView {
            if let parentUnit = parentUnit {
                List {
                    ForEach(parentUnit.availableCasesFor, id: \.self) { unit in
                        Button(unit.rawValue) {
                            coefficientToParentUnit = unit.coefficient(to: parentUnit) ?? 0
                            presentation.wrappedValue.dismiss()
                        }
                        .foregroundColor(.accentColor)
                        //  MARK: - FINISH THIS
                        //                            .foregroundColor(unit == ingredientUnit ? .systemOrange : .accentColor)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Select Unit")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("ERROR Ingredient Unit not set")
                    .foregroundColor(.systemRed)
                    .navigationTitle("ERROR")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
