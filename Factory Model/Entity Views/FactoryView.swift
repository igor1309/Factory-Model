//
//  FactoryView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import SwiftPI

struct FactoryView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentation
    
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(_ factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            FactoryDetailGroup(for: factory)
            
            SalesSections(for: factory)
            
            ProductionSection(for: factory)
            
            ProductionCostStructureSection(for: factory)
            
            FactoryProcurementSection(for: factory)
            
            FactoryPersonnelSection(for: factory)
            
            FactoryEquipmentSection(for: factory)
            
            FactoryExpensesSection(for: factory)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(factory.name, displayMode: .inline)
        .navigationBarItems(
            trailing: HStack(spacing: 16) {
                PeriodPicker(period: $settings.period, compact: true)
                CreateEntityPickerButton(factory: factory, isTabItem: true)
            }
        )
    }
}

fileprivate struct FactoryDetailGroup: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Group {
            Section(header: Text("Factory Detail")) {
                NavigationLink(destination: FactoryEditor(factory)) {
                    ListRow(factory, period: settings.period)
                }
            }
            
            reportsSection
            
            issuesSection
        }
    }
    
    private var reportsSection: some View {
        Section(
            header: Text("Reports")
                .foregroundColor(.systemOrange)
        ) {
            NavigationLink(
                destination: ReportsView(for: factory)
            ) {
                ListRow(
                    title: "Reports",
                    subtitle: "",
                    detail: "",
                    icon: "books.vertical",
                    color: .systemOrange
                )
            }
        }
    }
    
    private var issuesSection: some View {
        //  MARK: - FINISH THIS hasIssues does not work - need to use fetch
        //  if factory.hasIssues {
        Section(
            header: Text("Issues")
                .foregroundColor(.systemRed)
        ) {
            Group {
                NavigationLink(
                    destination: IssuesList(for: factory)
                ) {
                    ListRow(
                        title: "Issues",
                        subtitle: "Factory data has issues.",
                        detail: "Please check and fix orphans.",
                        icon: "exclamationmark.octagon.fill",
                        color: .systemRed
                    )
                }
            }
        }
        //  }
    }
}

fileprivate struct FactoryProcurementSection: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(header: Text("Procurement")) {
            Group {
                NavigationLink(
                    destination: IngredientList(for: factory)
                ) {
                    ListRow(
                        title: "Ingredients",
                        subtitle: factory.ingredientsDetail(in: settings.period),
                        detail: "",
                        icon: Ingredient.icon,
                        color: Ingredient.color
                    )
                }
                
                NavigationLink(
                    destination: PackagingList(for: factory)
                ) {
                    ListRow(
                        title: "Packaging",
                        subtitle: factory.packagingDetail,
                        detail: "",
                        icon: Packaging.icon,
                        color: Packaging.color
                    )
                }
            }
        }
    }
}

fileprivate struct FactoryPersonnelSection: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(header: Text("Personnel")) {
            Group {
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
    }
}

fileprivate struct FactoryEquipmentSection: View {
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(header: Text("Equipment")) {
            NavigationLink(
                destination: EquipmentList(for: factory)
            ) {
                //  MARK: more clever depreciation?
                
                ListRow(
                    title: "Salvage Value [TBD amount]",
                    subtitle: "Cost basis [TBD amount]",
                    detail: "TBD: Depreciation details",
                    icon: Equipment.icon,
                    color: Equipment.color
                )
            }
        }
    }
}

fileprivate struct FactoryExpensesSection: View {
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(header: Text("Expenses")) {
            NavigationLink(
                destination: ExpensesList(for: factory)
            ) {
                ListRow(
                    title: "Other Expenses [TBD amount]",
                    icon: Expenses.icon,
                    color: Expenses.color
                )
            }
        }
    }
}

struct FactoryView_Previews: PreviewProvider {
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    FactoryDetailGroup(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Group One", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 800))
            
            NavigationView {
                List {
                    SalesSections(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("SalesSections", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 820))
            
            NavigationView {
                List {
                    ProductionSection(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("ProductionSection", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 600))
            
            NavigationView {
                List {
                    ProductionCostStructureSection(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("ProductionCostStructureSection", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 400))
            
            NavigationView {
                List {
                    FactoryProcurementSection(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("FactoryProcurementSection", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 300))
            
            NavigationView {
                List {
                    FactoryPersonnelSection(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("FactoryPersonnelSection", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 300))
            
            NavigationView {
                List {
                    FactoryEquipmentSection(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("FactoryEquipmentSection", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 300))
            
            NavigationView {
                List {
                    FactoryExpensesSection(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("FactoryExpensesSection", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 250))
            
//            NavigationView {
//                FactoryView(Factory.example)
//            }
//            .previewLayout(.fixed(width: 350, height: 1200))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(settings)
        .preferredColorScheme(.dark)
    }
}
