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
    
    @ObservedObject var factory: Factory
    
    @Binding var period: Period
    
    init(_ factory: Factory, in period: Binding<Period>) {
        self.factory = factory
        _period = period
    }
    
    var body: some View {
        List {
            PeriodPicker(icon: "deskclock", title: "Period", period: $period)
            
            Section(
                header: Text("Factory Detail")
            ) {
                NavigationLink(
                    destination: FactoryEditor(factory)
                ) {
                    ListRow(factory)
                }
            }
            
            Group {
                reportsSection
                
                issuesSection
                
                salesSection
                
                productionSection
                
                costStructureSection
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
        .navigationTitle(factory.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var reportsSection: some View {
        Section(
            header: Text("Reports")
                .foregroundColor(.systemOrange)
        ) {
            NavigationLink(
                destination: ReportsView(for: factory, in: period)
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
                    destination: IssuesList(for: factory, in: period)
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

    private var salesSection: some View {
        Section(
            header: Text("Sales")
        ) {
            VStack(alignment: .leading, spacing: 9) {
                DataPointsView(dataBlock: factory.revenueDataPoints(in: period, title: "Products"))
                    .foregroundColor(Product.color)
                
                DataPointsView(dataBlock: factory.basesRevenueDataPoints(in: period, title: "Base Products"))
                    .foregroundColor(Base.color)
            }
            .padding(.vertical, 3)
            
            
            Group {
                NavigationLink(
                    destination: AllSalesList(for: factory, in: period)
                ) {
                    LabelWithDetail(Sales.icon, "Revenue, ex VAT", factory.revenueExVAT(in: period).formattedGrouped)
                }
                .foregroundColor(Sales.color)
                
                NavigationLink(
                    destination: AllBuyersList(for: factory, in: period)
                ) {
                    LabelWithDetail(Buyer.icon, "All Buyers", "")
                }
                .foregroundColor(Buyer.color)
            }
            .font(.subheadline)
        }
    }
    
    private var productionSection: some View {
        Section(
            header: Text("Production")
        ) {
            Group {
                VStack(alignment: .leading, spacing: 9) {
                    DataPointsView(dataBlock: factory.productionWeightNettoDataPoints(in: period, title: "Products, t"))
                        .foregroundColor(Product.color)
                    
                    DataPointsView(dataBlock: factory.basesProductionWeightNettoDataPoints(in: period, title: "Base Products, t"))
                        .foregroundColor(Base.color)
                }
                .padding(.vertical, 3)
                
                NavigationLink(
                    destination:
                        List {
                            ProductionOutputSection(for: factory, in: period)
                        }
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("Output")
                ) {
                    ListRow(
                        title: "Output",
                        subtitle: "TBD ...(?)",
                        detail: "Production Benchmarks?",
                        icon: "cylinder.split.1x2.fill",
                        color: .systemPurple
                    )
                }
                
                NavigationLink(
                    destination: ProductList(for: factory, in: period)
                ) {
                    ListRow(
                        title: "Products",
                        subtitle: factory.productsDetail(in: period),
                        detail: "",
                        icon: Product.icon,
                        color: Product.color
                    )
                }
                
                NavigationLink(
                    destination: BaseList(for: factory, in: period)
                ) {
                    ListRow(
                        title: "Base Products",
                        subtitle: factory.basesDetail(in: period),
                        detail: "",
                        icon: Base.icon,
                        color: Base.color
                    )
                }
            }
        }
    }
    
    private var costStructureSection: some View {
        Section(
            header: Text("Base Products Cost Structure")
        ) {
            VStack(alignment: .leading, spacing: 9) {
                DataPointsView2(dataBlock: factory.ingredientCostExVATDataPoints(in: period))
                    .foregroundColor(Ingredient.color)
                DataPointsView2(dataBlock: factory.salaryWithTaxDataPoints(in: period))
                    .foregroundColor(Employee.color)
                DataPointsView2(dataBlock: factory.depreciationWithTaxDataPoints(in: period))
                    .foregroundColor(Equipment.color)
                DataPointsView2(dataBlock: factory.utilitiesExVATDataPoints(in: period))
                    .foregroundColor(Utility.color)
            }
            .padding(.vertical, 3)
        }
    }
    
    private var procurementSection: some View {
        Section(
            header: Text("Procurement")
        ) {
            Group {
                NavigationLink(
                    destination: AllIngredientList(for: factory, in: period)
                ) {
                    ListRow(
                        title: "Ingredients",
                        subtitle: factory.ingredientsDetail(in: period),
                        detail: "",
                        icon: Ingredient.icon,
                        color: Ingredient.color
                    )
                }
                
                NavigationLink(
                    destination: PackagingList(for: factory, in: period)
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
                    destination: DivisionList(for: factory, in: period)
                ) {
                    ListRow(
                        title: "Divisions",
                        subtitle: "Salary incl taxes \(factory.salaryWithTax(in: period).formattedGrouped)",
                        detail: factory.divisionNames,
                        icon: "person.crop.rectangle",
                        color: Division.color
                    )
                }
                
                NavigationLink(
                    destination: AllEmployeesList(for: factory, in: period)
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
                destination: EquipmentList(for: factory, in: period)
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
                destination: ExpensesList(for: factory, in: period)
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
