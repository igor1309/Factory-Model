//
//  FactoryPersonnelSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.11.2020.
//

import SwiftUI

struct FactoryPersonnelSection: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(header: Text("Personnel")) {
            costView()
            people()
            divisions()
        }
    }
    
    @ViewBuilder
    private func costView() -> some View {
        CostView(factory.personnelByDepartmentTypeCost(in: settings.period))
        
        NavigationLink(
            destination: PersonnelCostStructure(for: factory)
        ) {
            Label("Details", systemImage: "rectangle.stack.person.crop")
                .foregroundColor(.systemTeal)
                .font(.subheadline)
        }
    }
    
    private func divisions() -> some View {
        NavigationLink(
            destination: DivisionList(for: factory)
        ) {
            ListRow(
                title: "Divisions",
                subtitle: "Salary incl taxes \(factory.salaryWithTax(in: settings.period).formattedGrouped)",
                detail: factory.divisionNames,
                icon: "person.crop.rectangle",
                color: Division.color
            )
        }
    }
    
    private func people() -> some View {
        NavigationLink(
            destination: EmployeeList(for: factory)
        ) {
            ListRow(
                title: "People (\(factory.headcount.formattedGrouped))",
                icon: Department.icon,
                color: Department.color
            )
        }
    }
}

struct PersonnelCostStructure: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            CostSection<EmptyView>(factory.personnelByDepartmentTypeCost(in: settings.period))
            
            CostSection<EmptyView>(factory.personnelByDivisionCost(in: settings.period))
            
            CostSection<EmptyView>(factory.personnelByDepartmentCost(in: settings.period))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Personnel Cost Structure")
        
    }
}

struct FactoryPersonnelSection_Previews: PreviewProvider {
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    FactoryPersonnelSection(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("FactoryPersonnelSection", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 450))
            
            NavigationView {
                PersonnelCostStructure(for: Factory.example)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .previewLayout(.fixed(width: 350, height: 650))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(settings)
        .preferredColorScheme(.dark)
    }
}
