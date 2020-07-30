//
//  DivisionView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct DivisionView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var division: Division
    
    init(for division: Division) {
        self.division = division
    }
    
    var body: some View {
        ListWithDashboard(
            title: division.name,
            parent: division,
//            keyPath: \Division.departments_,
            
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

                    LabelWithDetail("person.crop.rectangle", "Total Headcount", "TBD")

                    LabelWithDetail("dollarsign.square", "Total Salary incl taxes", "\(division.totalSalaryWithTax.formattedGrouped)")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        } editor: { (department: Department) in
            DepartmentView(for: department)
        }
    }
}
