//
//  ExpensesView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesView: View {
    @Environment(\.managedObjectContext) var сontext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var expenses: Expenses
    
    init(expenses: Expenses) {
        self.expenses = expenses
    }
    
    var body: some View {
        List {
            Section(header: Text("Expenses")) {
                Group {
                    TextField("Name", text: $expenses.name)
                    TextField("Name", text: $expenses.note)
                    Text("TBD: Qty: \(expenses.amount, specifier: "%.f")")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(expenses.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            сontext.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct ExpensesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpensesView()
//    }
//}
