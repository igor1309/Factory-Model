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
        EntityListWithDashboard(for: factory) {
            Section(
                header: Text("Total"),
                footer: Text("Expenses other than Salary (Personnel) and Utilities (Production).")
            ) {
                LabelWithDetail("Expenses Total", factory.expensesExVAT.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } editor: { (expenses: Expenses) in
            ExpensesView(expenses)
        }
    }
}
