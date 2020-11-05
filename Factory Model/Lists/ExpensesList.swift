//
//  ExpensesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesList: View {    
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        EntityListWithDashboard(
            for: factory,
            in: period
        ) {
            Section(
                header: Text("Total"),
                footer: Text("Expenses other than Salary (Personnel) and Utilities (Production).")
            ) {
                LabelWithDetail("Expenses Total", factory.expensesExVAT(in: period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } editor: { (expenses: Expenses) in
            ExpensesEditor(expenses)
        }
    }
}

struct ExpensesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpensesList(for: Factory.preview, in: .month())
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .preferredColorScheme(.dark)
        }
    }
}
