//
//  ChildUnitPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 07.08.2020.
//

import SwiftUI

struct ChildUnitPicker<T: HavingParentUnit & CustomUnitable>: View {
    @ObservedObject var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    
    @State private var showTable = false
    
    var body: some View {
        Button(entity.customUnitString) {
            showTable = true
        }
        .foregroundColor(entity.customUnitString == "??" ? .systemRed : .accentColor)
        .sheet(isPresented: $showTable) {
            ChildUnitPickerTable(entity)
        }
    }
}

fileprivate struct ChildUnitPickerTable<T: HavingParentUnit>: View {
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        NavigationView {
            if let parentUnit = entity.parentUnit {
                List {
                    ForEach(parentUnit.availableCasesFor, id: \.self) { unit in
                        Button(unit.rawValue) {
                            entity.coefficientToParentUnit = unit.coefficient(to: parentUnit) ?? 0
                            entity.objectWillChange.send()
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

struct ChildUnitPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ChildUnitPicker(Recipe.example)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}
