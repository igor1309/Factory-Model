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
    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(_ factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Factory Detail")
            ) {
                NavigationLink(destination: FactoryEditor(factory)) {
                    ListRow(factory, period: settings.period)
                }
            }
            
            Group {
                reportsSection
                
                issuesSection
                
                SalesSection(for: factory)
                
                CostSection(factory.sold(in: settings.period).cost)
                
                CostSection(factory.produced(in: settings.period).cost)
                
                ProductionSection(for: factory)
                
                CostStructureSection(for: factory)
            }
            
            Group {
                procurementSection
                
                personnelSection
                
                expensesSection
                
                equipmentSection
            }
            
            oldSection
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(factory.name, displayMode: .inline)
        .navigationBarItems(trailing: PeriodPicker(period: $settings.period, compact: true))
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
    
    private var procurementSection: some View {
        Section(
            header: Text("Procurement")
        ) {
            Group {
                NavigationLink(
                    destination: AllIngredientList(for: factory)
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
    
    private var personnelSection: some View {
        Section(
            header: Text("Personnel")
        ) {
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
                    destination: DepartmentList(for: factory)
                ) {
                    ListRow(
                        title: "Departments",
                        subtitle: "TBD: what here???",
                        detail: "TBD: factory.depertmentNames",
                        icon: "person.crop.rectangle",
                        color: Department.color
                    )
                }
                
                NavigationLink(
                    destination: AllEmployeesList(for: factory)
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
    
    private var equipmentSection: some View {
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
    
    private var expensesSection: some View {
        Section(
            header: Text("Expenses")
        ) {
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
    
    private var oldSection: some View {
        Section(
            header: Text("Old")
        ) {
            Group {
                NavigationLink(
                    destination: Text("Production TBD")
                ) {
                    LabelWithDetail("bag.fill.badge.plus", "Production", "TBD")
                }
            }
            .font(.subheadline)
        }
    }
}

struct FactoryView_Previews: PreviewProvider {
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        NavigationView {
            FactoryView(Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(settings)
        .preferredColorScheme(.dark)
    }
}
