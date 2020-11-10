//
//  AllEmployeesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct AllEmployeesList: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            childType: Employee.self,
            predicate: Employee.factoryPredicate(for: factory)
        ) {
            CreateNewEntityBarButton<Employee>()
            
            //  MARK: - FINISH THIS FUGURE OUT HOW TO CREATE ENTITY HERE
            // EmptyView()
            /*
            CreateChildButton(
                systemName: "cart.badge.plus",
                childType: Employee.self, parent: factory,
                keyPath: \Factory.employees_
            ) */
        } dashboard: {
            
        }
    }
}

struct AllEmployeesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllEmployeesList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
