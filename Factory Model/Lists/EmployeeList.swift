//
//  EmployeeList.swift
//  Department Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EmployeeList: View {
    @ObservedObject var department: Department
    
    let period: Period
    
    init(at department: Department, in period: Period) {
        self.department = department
        self.period = period
    }
    
    var body: some View {
        ListWithDashboard(
            for: department,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Employee.department), department
            ),
            in: period
        ) {
            CreateChildButton(
                systemName: Employee.plusButtonIcon,
                childType: Employee.self,
                parent: department,
                keyPath: \Department.employees_
            )
        } dashboard: {
            Section(header: Text("Total")) {
                LabelWithDetail("Salary incl taxes", department.salaryWithTax(in: period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } editor: { (employee: Employee) in
            EmployeeEditor(employee)
        }
        
    }
}

struct EmployeeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmployeeList(at: Department.preview, in: .month())
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .preferredColorScheme(.dark)
        }
    }
}
