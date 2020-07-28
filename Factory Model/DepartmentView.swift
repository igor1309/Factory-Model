//
//  StaffRowWithList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI

struct DepartmentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var department: Department
    
    init(for department: Department) {
        self.department = department
    }
    
    var body: some View {
        ListWithDashboard(
            parent: department,
            pathFromParent: "staffs_",
            keyPath: \Staff.department!,
            
            //  MARK: - FINISH THIS
            //  should be `default` predicate
            //            format: "%K == %@", #keyPath(Product.base.factory), factory

            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Staff.department), department
            ),
            
            
            useSmallerFont: true
        ) {
            Section(header: Text("Total")) {
                LabelWithDetail("Total Salary incl taxes", "factory.totalSalaryWithTax")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Text("MARK: NEED TO BE DONE IN A CORRECT WAY")
                .foregroundColor(.systemRed)
                .font(.headline)
        } editor: { staff in
            StaffView(staff)
        }
    }
}
