//
//  ExpensesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesList: View {
    @Environment(\.managedObjectContext) var сontext
    
    @FetchRequest private var expenses: FetchedResults<Expenses>
    
//    @ObservedObject
    var factory: Factory
    
    init(at factory: Factory) {
        self.factory = factory
        _expenses = FetchRequest(
            entity: Expenses.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Expenses.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@", factory
            )
        )
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
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let expenses = Expenses(context: сontext)
            expenses.name = " ..."
            expenses.note = "..."
            expenses.amount = 10_000
            factory.addToExpenses_(expenses)
            сontext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeExpenses(at offsets: IndexSet) {
        for index in offsets {
            let expense = expenses[index]
            сontext.delete(expense)
        }
        
        сontext.saveContext()
    }
}

//struct ExpensesList_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpensesList()
//    }
//}
