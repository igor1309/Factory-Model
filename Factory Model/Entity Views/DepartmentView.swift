//
//  EmployeeRowWithList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI

struct DepartmentView: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var department: Department
    
    init(_ department: Department) {
        self.department = department
        
        //  MARK: - FINISH THIS
        //  should be `default` predicate
        //  format: "%K == %@", #keyPath(Product.base.factory), factory
        predicate = NSPredicate(format: "%K == %@", #keyPath(Employee.department), department)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            childType: Employee.self,
            title: department.name,
            predicate: predicate
        ) {
            CreateChildButton(
                childType: Employee.self,
                parent: department,
                keyPathToParent: \Employee.department
            )
        } dashboard: {
            Section(
                header: Text("Department Detail")
            ) {
                NavigationLink(
                    destination: DepartmentEditor(department)
                ) {
                    ListRow(department, period: settings.period)
                }
            }
            
            ErrorMessage(department)
            
            LaborView(for: department)
        }
    }
}

struct DepartmentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepartmentView(Department.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 950))
    }
}
