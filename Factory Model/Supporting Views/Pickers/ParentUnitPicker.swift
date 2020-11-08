//
//  ParentUnitPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 08.08.2020.
//

import SwiftUI

struct ParentUnitPicker<T: CustomUnitable>: View {
    @ObservedObject var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    
    @State private var showTable = false
    
    var body: some View {
        Button {
            showTable = true
        } label: {
            Text(entity.customUnitString)
                .foregroundColor(entity.customUnit == nil ? .systemRed : .accentColor)
        }
        .sheet(isPresented: $showTable) {
            UnitPickerTable(entity)
        }
    }
}

fileprivate struct UnitPickerTable<T: CustomUnitable>: View {
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(CustomUnit.allCases, id: \.self) { unit in
                    Button(unit.rawValue) {
                        entity.customUnit = unit
                        entity.objectWillChange.send()
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

struct ParentUnitPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ParentUnitPicker(Base.example)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}
