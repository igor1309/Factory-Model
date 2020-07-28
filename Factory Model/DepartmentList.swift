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
            pathFromParent: "departments_",
            keyPath: \Department.factory!,
            predicate: Department.factoryPredicate(for: factory),
            useSmallerFont: true
        ) {
            Text("TBD: Departments")
                .foregroundColor(.systemRed)
        } editor: { department in
            DepartmentView(for: department)
        }
    }
}
