//
//  ExpensesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var expenses: FetchedResults<Expenses>
    
    var factory: Factory
    
    init(at factory: Factory) {
        self.factory = factory
        
        let predicate = Expenses.factoryPredicate(for: factory)
        _expenses = Expenses.defaultFetchRequest(with: predicate)
    }
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                LabelWithDetail("Expenses Total", factory.expensesTotal.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Expenses")) {
                ForEach(expenses, id: \.objectID) { expenses in
                    NavigationLink(
                        destination: ExpensesView(expenses: expenses)
                    ) {
                        ListRow(expenses)
                    }
                }
                .onDelete(perform: removeExpenses)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Expenses")
        .navigationBarItems(trailing: PlusEntityButton<Expenses>(factory: factory))
    }
    
    private func removeExpenses(at offsets: IndexSet) {
        for index in offsets {
            let expense = expenses[index]
            moc.delete(expense)
        }
        moc.saveContext()
    }
}
