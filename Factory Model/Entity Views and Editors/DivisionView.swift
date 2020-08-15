//
//  DivisionView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct DivisionView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var division: Division
    
    init(_ division: Division) {
        self.division = division
    }
    
    var body: some View {
        ListWithDashboard(
            for: division,
            title: division.name,
            
            //  MARK: - FINISH THIS
            //  should be `default` predicate
            //            format: "%K == %@", #keyPath(Product.base.factory), factory
            
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Department.division), division
            )
            
        ) {
            CreateChildButton(
                systemName: "rectangle.badge.plus",
                childType: Department.self,
                parent: division,
                keyPath: \Division.departments_
            )
        } dashboard: {
            Section(
                header: Text("Division")
            ) {
                Group {
                    TextField("Division Name", text: $division.name)
                        .foregroundColor(.accentColor)

                    LabelWithDetail("person.crop.rectangle", "Total Headcount", division.headcount.formattedGrouped)

                    LabelWithDetail("dollarsign.square", "Total Salary incl taxes", "\(division.totalSalaryWithTax.formattedGrouped)")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            //  parent check
            if division.factory == nil {
                Section(
                    header: Text("Factory")
                ) {
                    EntityPicker(selection: $division.factory, icon: "building.2")
                        .foregroundColor(.systemRed)
                }
            }
        } editor: { (department: Department) in
            DepartmentView(department)
        }
    }
}
