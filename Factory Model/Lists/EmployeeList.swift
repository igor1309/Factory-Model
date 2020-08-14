//
//  EmployeeList.swift
//  Department Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EmployeeList: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var department: Department
    
    init(at department: Department) {
        self.department = department
    }
    
    var body: some View {
        ListWithDashboard(
            for: department,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Employee.department), department
            )
        ) {
            CreateChildButton(
                systemName: Department.icon,
                childType: Employee.self,
                parent: department,
                keyPath: \Department.employees_
            )
        } dashboard: {
            Section(header: Text("Total")) {
                LabelWithDetail("Total Salary incl taxes", department.salaryWithTax.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } editor: { (employee: Employee) in
            EmployeeView(employee)
        }
        
    }
}
