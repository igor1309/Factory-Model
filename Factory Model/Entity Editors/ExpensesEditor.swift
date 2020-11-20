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
    
    init(isPresented: Binding<Bool>, factory: Factory? = nil) {
        _isPresented = isPresented
        
        expensesToEdit = nil
        
        _name =    State(initialValue: "")
        _factory = State(initialValue: factory)
        _amount =  State(initialValue: 0)
        _period =  State(initialValue: .month())
        _note =    State(initialValue: "")
        
        title = "New Expenses"
    }
    
    init(_ expenses: Expenses) {
        _isPresented = .constant(true)
        
        expensesToEdit = expenses
        
        _name =    State(initialValue: expenses.name)
        _factory = State(initialValue: expenses.factory)
        _amount =  State(initialValue: expenses.amount)
        _period =  State(initialValue: expenses.period)
        _note =    State(initialValue: expenses.note)
        
        title = "Edit Expenses"
    }
    
    @State private var name: String
    @State private var factory: Factory?
    @State private var amount: Double
    @State private var period: Period
    @State private var note: String
    
    var body: some View {
        List {
            NameSection<Expenses>(name: $name)
            
            AmountPicker(systemName: Expenses.icon, title: "Amount", navigationTitle: "Amount", scale: .extraLarge, amount: $amount)
                .foregroundColor(amount > 0 ? .accentColor : .systemRed)
            
            PeriodPicker(period: $period)
            
            EntityPickerSection(selection: $factory, period: period)
            
            NoteSection(note: $note)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let haptics = Haptics()
            haptics.feedback()
            
            withAnimation {
                var expenses: Expenses
                
                if let expensesToEdit = expensesToEdit {
                    expenses = expensesToEdit
                    expenses.objectWillChange.send()
                } else {
                    expenses = Expenses(context: context)
                }
                
                expenses.factory?.objectWillChange.send()
                
                expenses.name = name
                expenses.amount = amount
                expenses.period = period
                expenses.note = note
                expenses.factory = factory
                
                context.saveContext()
                
                isPresented = false
                presentation.wrappedValue.dismiss()
            }
        }
        .disabled(factory == nil || name.isEmpty || amount == 0)
    }
}

struct ExpensesEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    ExpensesEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 580))
            
            NavigationView {
                VStack {
                    ExpensesEditor(Expenses.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 580))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
