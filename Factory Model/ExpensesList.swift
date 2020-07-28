//
//  ExpensesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesList: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            parent: factory,
            pathFromParent: "expenses_",
            keyPath: \Expenses.factory!,
            predicate: Expenses.factoryPredicate(for: factory),
            useSmallerFont: true
        ) {            
            Section(header: Text("Total")) {
                LabelWithDetail("Expenses Total", factory.expensesTotal.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } editor: { expenses in
            ExpensesView(expenses)
        }
    }
}
