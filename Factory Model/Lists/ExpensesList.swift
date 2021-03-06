//
//  ExpensesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct ExpensesList: View {    
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(for: factory, keyPathToParent: \Expenses.factory, dashboard: dashboard)
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        Section(
            header: Text("Total"),
            footer: Text("Expenses other than Salary (Personnel) and Utilities (Production).")
        ) {
            LabelWithDetail("Expenses Total", factory.expensesExVAT(in: settings.period).formattedGrouped)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
    }
}

struct ExpensesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpensesList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
