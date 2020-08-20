//
//  EmployeeRowWithList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI

struct DepartmentView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var department: Department
    
    init(_ department: Department) {
        self.department = department
    }
    
    var body: some View {
        ListWithDashboard(
            for: department,
            title: department.name,
            
            //  MARK: - FINISH THIS
            //  should be `default` predicate
            //            format: "%K == %@", #keyPath(Product.base.factory), factory
            
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Employee.department), department
            )
            
        ) {
            CreateChildButton(
                systemName: "person.badge.plus",
                childType: Employee.self,
                parent: department,
                keyPath: \Department.employees_
            )
        } dashboard: {
            Section(
                header: Text("Department Detail")
            ) {
                NavigationLink(
                    destination: DepartmentEditor(department)
                ) {
                    ListRow(department)
                }
            }
            
            ErrorMessage(department)
            
            Section(
                header: Text("Headcount and Salary")
            ) {
                Group {
                    LabelWithDetail("person.crop.rectangle", "Total Headcount", department.headcount.formattedGrouped)
                    
                    LabelWithDetail("dollarsign.square", "Total Salary incl taxes", department.salaryWithTax.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
        } editor: { (employee: Employee) in
            EmployeeEditor(employee)
        }
    }
}
