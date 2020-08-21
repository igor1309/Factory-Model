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
    
    init(_ factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
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
                booksSection
                
                issuesSection
                
                salesSection
                
                productionSection
            }
            
            Group {
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
    
    private var booksSection: some View {
        Section(
            header: Text("Books")
                .foregroundColor(.systemOrange)
        ) {
            NavigationLink(
                destination: BooksView(for: factory)
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
                        subtitle: "Total Salary incl taxes \(factory.salaryWithTax.formattedGrouped)",
                        detail: factory.divisionNames,
                        icon: "person.crop.rectangle",
                        color: Division.color
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
    
    private var productionSection: some View {
        Section(
            header: Text("Production")
        ) {
            Group {
                NavigationLink(
                    destination: ProductList(for: factory)
                ) {
                    ListRow(
                        title: "Products",
                        subtitle: "TBD: .................",
                        detail: "TBD: Base products with production volume (in their units): Сулугуни 1 ru (8,000), Сулугуни 0.5 кг (3,000), Хинкали 12 шт (1,250)",
                        icon: Product.icon,
                        color: Product.color
                    )
                }
                
                NavigationLink(
                    destination: BaseList(for: factory)
                ) {
                    ListRow(
                        title: "Base Products",
                        subtitle: ".................",
                        detail: "TBD: Base products with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)",
                        icon: Base.icon,
                        color: Base.color
                    )
                }
                
                NavigationLink(
                    destination: AllIngredientList(for: factory)
                ) {
                    ListRow(
                        title: "Ingredients",
                        subtitle: "TBD: .................",
                        detail: "TBD: some extra top-level details(?)",
                        icon: Ingredient.icon,
                        color: Ingredient.color
                    )
                }
                
                NavigationLink(
                    destination: PackagingList(for: factory)
                ) {
                    ListRow(
                        title: "Packaging",
                        subtitle: "TBD: .................",
                        detail: "TBD: List of packaging types (??)",
                        icon: Packaging.icon,
                        color: Packaging.color
                    )
                }
            }
        }
    }
    
    private var salesSection: some View {
        Section(
            header: Text("Sales")
        ) {
            Group {
                NavigationLink(
                    destination: AllSalesList(for: factory)
                ) {
                    LabelWithDetail(Sales.icon, "Total revenue, ex VAT", factory.revenueExVAT.formattedGrouped)
                }
                .foregroundColor(Sales.color)
                
                NavigationLink(
                    destination: AllBuyersList(for: factory)
                ) {
                    LabelWithDetail(Buyer.icon, "All Buyers", "")
                }
                .foregroundColor(Buyer.color)
            }
            .font(.subheadline)
        }
    }
}
