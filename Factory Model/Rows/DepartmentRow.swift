//
//  DepartmentRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI

struct DepartmentRow: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        
        let departmentList = ListWithDashboard(
            title: "Departments",
            parent: factory,
            path: "departments_",
            keyPath: \Department.factory!,
            predicate: Department.factoryPredicate(for: factory),
            useSmallerFont: true
        ) {
            Text("TBD: Departments")
                .foregroundColor(.systemRed)
            
        } editor: { (department: Department) in
            DepartmentView(department)
        }
        
        NavigationLink(
            destination: departmentList
        ) {
            ListRow(
                title: "TBD: Departments",
                subtitle: ".................",
                icon: "person.2.circle"
            )
            .foregroundColor(.systemTeal)
        }
    }
}
