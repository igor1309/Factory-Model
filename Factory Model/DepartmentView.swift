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
            keyPath: \Department.staffs_,
            
            //  MARK: - FINISH THIS
            //  should be `default` predicate
            //            format: "%K == %@", #keyPath(Product.base.factory), factory
            
            predicate: nil
//                NSPredicate(
//                    format: "%K == %@", #keyPath(Staff.department), department
//                )
            
            
            
        ) {
            CreateChildButton(
                systemName: "person.crop.circle.badge.plus",
                childType: Staff.self,
                parent: department,
                keyPath: \Department.staffs_
            )
        } dashboard: {
            Section(
                header: Text("Total")
            ) {
                LabelWithDetail("Total Salary incl taxes", "\(department.totalSalaryWithTax.formattedGrouped)")
                    .font(.subheadline)
            }
        } editor: { (staff: Staff) in
            StaffView(staff)
        }
    }
}
