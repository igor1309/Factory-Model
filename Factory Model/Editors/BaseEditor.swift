//
//  BaseEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct BaseEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let baseToEdit: Base?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        baseToEdit = nil
        
        _factory = State(initialValue: nil)
        _name = State(initialValue: "")
        _unitString_ = State(initialValue: "")
        _code = State(initialValue: "")
        _group = State(initialValue: "")
        _note = State(initialValue: "")
        _initialInventory = State(initialValue: 0)
        _weightNetto = State(initialValue: 0)
        
        title = "New Base"
    }

    init(base: Base) {
        _isPresented = .constant(true)
        
        baseToEdit = base

        _factory = State(initialValue: base.factory)
        _name = State(initialValue: base.name)
        _unitString_ = State(initialValue: base.unitString_ ?? "")
        _code = State(initialValue: base.code)
        _group = State(initialValue: base.group)
        _note = State(initialValue: base.note)
        _initialInventory = State(initialValue: base.initialInventory)
        _weightNetto = State(initialValue: base.weightNetto)
        
        title = "Edit Base"
    }
        
    @State private var factory: Factory?
    @State private var name: String
    @State private var group: String
    @State private var code: String
    @State private var note: String
    @State private var unitString_: String
    @State private var initialInventory: Double
    @State private var weightNetto: Double
    
    var body: some View {
        List {
            NameGroupCodeNoteStringEditorSection(name: $name, group: $group, code: $code, note: $note)
            
            Section(
                header: Text("Unit")
            ) {
                ParentUnitStringPicker(unitString: $unitString_)
                    .foregroundColor(.accentColor)
            }
            
            Section(
                header: Text("Initial Inventory")
            ) {
                AmountPicker(systemName: "building.2.crop.circle.fill", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $initialInventory)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(initialInventory > 0 ? .accentColor : .systemRed)
            }
            
            Section(
                header: Text("Weight Netto")
            ) {
                AmountPicker(systemName: "scalemass", title: "Weight Netto", navigationTitle: "Weight", scale: .small, amount: $weightNetto)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(weightNetto > 0 ? .accentColor : .systemRed)
            }
            
            EntityPickerSection(selection: $factory)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                //  MARK: - FINISH THIS
                //  после создания base нужно перейти к списку base ingredients
                //  Button("Next")
                Button("Save") {
                    let base: Base
                    if let baseToEdit = baseToEdit {
                        base = baseToEdit
                    } else {
                        base = Base(context: context)
                    }
                    
                    base.factory = factory
                    base.name = name
                    base.unitString_ = unitString_
                    base.code = code
                    base.code = code
                    base.group = group
                    base.note = note
                    base.initialInventory = initialInventory
                    base.weightNetto = weightNetto
                    
                    //  MARK: - FINISH THIS
                    //  после создания base нужно перейти к списку base ingredients

                    context.saveContext()
                    
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(factory == nil || name.isEmpty || unitString_.isEmpty || weightNetto == 0)
            }
        }
    }
}
