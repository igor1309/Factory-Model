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
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            for: factory,
            title: "All Employees",
            predicate: Employee.factoryPredicate(for: factory)
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
            EmployeeEditor(employee)
        }
    }
}
