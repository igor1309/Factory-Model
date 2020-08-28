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
    
    let period: Period
    
    init(_ division: Division, in period: Period) {
        self.division = division
        self.period = period
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
            NameSection<Division>(name: $division.name)
            
            LaborView(for: division, in: period)
            
            //  parent check
            if division.factory == nil {
                EntityPickerSection(selection: $division.factory)                
            }
        } editor: { (department: Department) in
            DepartmentView(department, in: period)
        }
    }
}
