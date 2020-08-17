//
//  ExpensesView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var expenses: Expenses
    
    init(_ expenses: Expenses) {
        self.expenses = expenses
    }
    
    var body: some View {
        List {
            //  parent check
            if expenses.factory == nil {
                Section(
                    header: Text("Factory")
                ) {
                    EntityPicker(selection: $expenses.factory, icon: "building.2")
                        .foregroundColor(.systemRed)
                }
            }

            Section(
                header: Text("Details")
            ) {
                Group {
                    TextField("Name", text: $expenses.name)
                    TextField("Note", text: $expenses.note)
                    
                    AmountPicker(systemName: Expenses.icon, title: "Amount", navigationTitle: "Amount", scale: .extraLarge, amount: $expenses.amount)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(expenses.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
