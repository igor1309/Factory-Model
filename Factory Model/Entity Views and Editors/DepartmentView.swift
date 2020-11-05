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
    
    let period: Period
    
    init(_ department: Department, in period: Period) {
        self.department = department
        self.period = period
        
        //  MARK: - FINISH THIS
        //  should be `default` predicate
        //  format: "%K == %@", #keyPath(Product.base.factory), factory
        predicate = NSPredicate(format: "%K == %@", #keyPath(Employee.department), department)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            for: department,
            title: department.name,
            predicate: predicate,
            in: period
        ) {
            CreateChildButton(
                childType: Employee.self,
                parent: department,
                keyPath: \Department.employees_
            )
        } dashboard: {
            Section(
                header: Text("Department Detail")
            ) {
                NavigationLink(
                    destination: DepartmentEditor(department, in: period)
                ) {
                    ListRow(department)
                }
            }
            
            ErrorMessage(department)
            
            LaborView(for: department, in: period)
            
        } editor: { (employee: Employee) in
            EmployeeEditor(employee)
        }
    }
}

struct DepartmentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepartmentView(Department.preview, in: .month())
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
