//
//  ExpensesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var expenses: FetchedResults<Expenses>
    
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
                LabelWithDetail("Expenses Total", factory.expensesTotal.formattedGroupedWith1Decimal)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Expenses")) {
                ForEach(expenses, id: \.self) { expenses in
                    NavigationLink(
                        destination: ExpensesView(expenses: expenses, for: factory)
                    ) {
                        ListRow(
                            title: expenses.name,
                            subtitle: "\(expenses.amount)",
                            detail: expenses.note,
                            icon: "dollarsign.circle",
                            useSmallerFont: true
                        )
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
            let expenses = Expenses(context: managedObjectContext)
            expenses.name = " ..."
            expenses.note = "..."
            expenses.amount = 10_000
            factory.addToExpenses_(expenses)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeExpenses(at offsets: IndexSet) {
        for index in offsets {
            let expense = expenses[index]
            managedObjectContext.delete(expense)
        }
        
        managedObjectContext.saveContext()
    }
}

//struct ExpensesList_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpensesList()
//    }
//}
