//
//  DivisionList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct DivisionList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        EntityListWithDashboard(for: factory, keyPathToParent: \Division.factory, dashboard: dashboard)
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        
        LaborView(for: factory)
        
        Section(
            header: Text("Personnel")
        ) {
            Group {
                NavigationLink(
                    destination: EmployeeList(for: factory)
                ) {
                    Label("All Factory Personnel", systemImage: Department.icon)
                        .foregroundColor(Employee.color)
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
}

struct DivisionList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DivisionList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 850))
    }
}
