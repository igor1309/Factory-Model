//
//  ExpensesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesList: View {    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        EntityListWithDashboard(
            for: factory
        ) {
            Section(
                header: Text("Total"),
                footer: Text("Expenses other than Salary (Personnel) and Utilities (Production).")
            ) {
                LabelWithDetail("Expenses Total", factory.expensesExVAT(in: settings.period).formattedGrouped)
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
            ExpensesList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
