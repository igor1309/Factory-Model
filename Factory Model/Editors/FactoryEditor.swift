//
//  FactoryEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct FactoryEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let factoryToEdit: Factory?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        factoryToEdit = nil
        
        _name = State(initialValue: "")
        _note = State(initialValue: "")
        _profitTaxRate = State(initialValue: 20/100)
        
        title = "New Factory"
    }
    
    init(factory: Factory) {
        _isPresented = .constant(true)
        
        factoryToEdit = factory
        
        _name = State(initialValue: factory.name)
        _note = State(initialValue: factory.note)
        _profitTaxRate = State(initialValue: factory.profitTaxRate)
        
        title = "Edit Factory"
    }
    
    @State private var name: String
    @State private var note: String
    @State private var profitTaxRate: Double
    
    var body: some View {
        List {
            Section(
                header: Text(name.isEmpty ? "" : "Edit Factory Name")
            ) {
                TextField("Factory Name", text: $name)
            }
            
            Section(
                header: Text("Note")
            ) {
                TextField("Factory Note", text: $note)
            }
            
            AmountPicker(systemName: "scissors", title: "Profit Tax Rate", navigationTitle: "Profit Tax Rate", scale: .percent, amount: $profitTaxRate)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let factory: Factory
                    if let factoryToEdit = factoryToEdit {
                        factory = factoryToEdit
                    } else {
                        factory = Factory(context: context)
                    }
                    
                    factory.name = name
                    factory.note = note
                    factory.profitTaxRate = profitTaxRate
                    
                    context.saveContext()
                    
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || profitTaxRate == 0)
            }
        }
    }
}
