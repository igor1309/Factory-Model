//
//  ExpensesView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    var expenses: Expenses
    var factory: Factory
    
    @State private var draft: Expenses
    
    init(expenses: Expenses, for factory: Factory) {
        self.expenses = expenses
        self.factory = factory
        _draft = State(initialValue: expenses)
    }
    
    var body: some View {
        List {
            Section(header: Text("Expenses")) {
                Group {
                    TextField("Name", text: $draft.name)
                    TextField("Name", text: $draft.note)
                    Text("TBD: Qty: \(draft.amount, specifier: "%.f")")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
    }
}

//struct ExpensesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpensesView()
//    }
//}
