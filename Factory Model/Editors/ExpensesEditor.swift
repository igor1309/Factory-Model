//
//  ExpensesEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct ExpensesEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let expensesToEdit: Expenses?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        expensesToEdit = nil
        
        _name = State(initialValue: "")
        _factory = State(initialValue: nil)
        _amount = State(initialValue: 0)
        _note = State(initialValue: "")
        
        title = "New Expenses"
    }
    
    init(expenses: Expenses) {
        _isPresented = .constant(true)
        
        expensesToEdit = expenses
        
        _name = State(initialValue: expenses.name)
        _factory = State(initialValue: expenses.factory)
        _amount = State(initialValue: expenses.amount)
        _note = State(initialValue: expenses.note)
        
        title = "Edit Expenses"
    }
    
    @State private var name: String
    @State private var factory: Factory?
    @State private var amount: Double
    @State private var note: String
    
    var body: some View {
        List {
            Section(
                header: Text(name.isEmpty ? "" : "Edit Expenses Name")
            ) {
                TextField("Expenses Name", text: $name)
            }
            
            TextField("Expenses Note", text: $note)
            
            AmountPicker(systemName: Expenses.icon, title: "Amount", navigationTitle: "Amount", scale: .extraLarge, amount: $amount)
            
            EntityPickerSection(selection: $factory)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let expenses: Expenses
                    if let expensesToEdit = expensesToEdit {
                        expenses = expensesToEdit
                    } else {
                        expenses = Expenses(context: context)
                    }
                    
                    expenses.name = name
                    expenses.factory = factory
                    expenses.amount = amount
                    expenses.note = note
                    
                    context.saveContext()
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(factory == nil || name.isEmpty || amount == 0)
            }
        }
    }
}
