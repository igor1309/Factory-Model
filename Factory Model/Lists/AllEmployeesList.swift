//
//  AllEmployeesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct AllEmployeesList: View {
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        ListWithDashboard(
            for: factory,
            title: "All Employees",
            predicate: Employee.factoryPredicate(for: factory),
            in: period
        ) {
            //  MARK: - FINISH THIS FUGURE OUT HOW TO CREATE ENTITY HERE
            EmptyView()
            /*
            CreateChildButton(
                systemName: "cart.badge.plus",
                childType: Employee.self, parent: factory,
                keyPath: \Factory.employees_
            ) */
        } dashboard: {
            
        } editor: { (employee: Employee) in
            EmployeeEditor(employee, in: period)
        }
    }
}
