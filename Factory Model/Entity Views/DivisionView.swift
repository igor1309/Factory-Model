//
//  DivisionView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct DivisionView: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var division: Division
    
    init(_ division: Division) {
        self.division = division
        
        //  MARK: - FINISH THIS
        //  should be `default` predicate
        //  format: "%K == %@", #keyPath(Product.base.factory), factory
        predicate = NSPredicate(format: "%K == %@", #keyPath(Department.division), division)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            childType: Department.self,
            title: division.name
        ) {
            CreateChildButton(
                childType: Department.self,
                parent: division,
                keyPathToParent: \Department.division
            )
        } dashboard: {
            NameSection<Division>(name: $division.name)
            
            LaborView(for: division)
            
            //  parent check
            if division.factory == nil {
                EntityPickerSection(selection: $division.factory, period: settings.period)
            }
        }
    }
}

struct DivisionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DivisionView(Division.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
