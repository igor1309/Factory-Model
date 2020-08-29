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
    let period: Period
    
    init(isPresented: Binding<Bool>, in period: Period) {
        _isPresented = isPresented
        
        expensesToEdit = nil
        self.period = period
        
        _name = State(initialValue: "")
        _factory = State(initialValue: nil)
        _amount = State(initialValue: 0)
        _note = State(initialValue: "")
        
        title = "New Expenses"
    }
    
    init(_ expenses: Expenses, in period: Period) {
        _isPresented = .constant(true)
        
        expensesToEdit = expenses
        self.period = period
        
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
            NameSection<Expenses>(name: $name)
            
            AmountPicker(systemName: Expenses.icon, title: "Amount", navigationTitle: "Amount", scale: .extraLarge, amount: $amount)
            
            EntityPickerSection(selection: $factory, period: period)
            
            TextField("Expenses Note", text: $note)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
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
