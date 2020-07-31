//
//  ExpensesView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var expenses: Expenses
    
    init(_ expenses: Expenses) {
        self.expenses = expenses
    }
    
    var body: some View {
        List {
            Text("NEEDS TO BE COMPLETLY REDONE")
                .foregroundColor(.systemRed)
                .font(.headline)
            
//            Section(header: Text("Expenses")) {
//                Group {
//                    TextField("Name", text: $expenses.name)
//                    TextField("Name", text: $expenses.note)
//                    Text("TBD: Qty: \(expenses.amount, specifier: "%.f")")
//                }
//                .foregroundColor(.accentColor)
//                .font(.subheadline)
//            }
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
