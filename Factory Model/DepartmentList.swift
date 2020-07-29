//
//  DepartmentRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI

struct DepartmentList: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            parent: factory,
            keyPath: \Factory.departments_,
            predicate: Department.factoryPredicate(for: factory)
        ) {
            CreateChildButton(
                systemName: "person.crop.circle.badge.plus",
                childType: Department.self,
                parent: factory,
                keyPath: \Factory.departments_
            )
        } dashboard: {
            Section(
                header: Text("Total")
            ) {
                LabelWithDetail("Total Salary incl taxes", "\(factory.totalSalaryWithTax.formattedGrouped)")
                    .font(.subheadline)
            }
        } editor: { (department: Department) in
            DepartmentView(for: department)
        }
    }
}
