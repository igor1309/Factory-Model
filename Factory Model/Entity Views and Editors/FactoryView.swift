//
//  FactoryView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import SwiftPI

struct FactoryView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var factory: Factory
    
    init(_ factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            Group {
                issuesSection
                
                salesSection
            
                productionSection
            
                booksSection
            }
            
            Group {
                personnelSection
                
                expensesSection
                
                equipmentSection
            }
            
            Section(header: Text("Factory Details")) {
                Group {
                    TextField("Name", text: $factory.name)
                    TextField("Note", text: $factory.note)
                }
                .foregroundColor(.accentColor)
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
        ) {
            NavigationLink(
                destination: BooksView(factory: factory)
            ) {
                ListRow(
                    title: "Reports",
                    subtitle: "",
                    detail: "",
                    icon: "books.vertical"
                )
            }
        }
        .foregroundColor(.systemOrange)
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
                    detail: "TBD: amortization details",
                    icon: "wrench.and.screwdriver"
                )
            }
        }
        .foregroundColor(.purple)
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
                    icon: "dollarsign.circle"
                )
            }
        }
        .foregroundColor(.systemTeal)
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
                        icon: "exclamationmark.octagon.fill"
                    )
                    .foregroundColor(.systemRed)
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
                    destination: ProductList(for: factory)
                ) {
                    LabelWithDetail("bag.circle", "Product/Bases", "TBD")
                }
                
                NavigationLink(
                    destination: BaseList(for: factory)
                ) {
                    LabelWithDetail("bag", "Bases", "TBD")
                }
                
                NavigationLink(
                    destination: Text("Production TBD")
                ) {
                    LabelWithDetail("bag.fill.badge.plus", "Production", "TBD")
                }
                
                NavigationLink(
                    destination: AllFeedstockList(for: factory)
                ) {
                    LabelWithDetail("puzzlepiece", "Feedstocks", factory.totalFeedstockCostExVAT.formattedGrouped)
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
                        subtitle: "Total Salary incl taxes \(factory.totalSalaryWithTax.formattedGrouped) (\(factory.headcount) people)",
                        detail: factory.divisionNames,
                        icon: "person.crop.rectangle"
                    )
                }
                
                NavigationLink(
                    destination: AllWorkersList(for: factory)
                ) {
                    ListRow(
                        title: "People (\(factory.headcount.formattedGrouped))",
                        icon: "person.2"
                    )
                }
            }
        }
        .foregroundColor(.systemTeal)
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
                        icon: "bag"
                    )
                    .foregroundColor(.systemOrange)
                }
                
                NavigationLink(
                    destination: BaseList(for: factory)
                ) {
                    ListRow(
                        title: "Base Products",
                        subtitle: ".................",
                        detail: "TBD: Base products with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)",
                        icon: "bag.circle"
                    )
                    .foregroundColor(.systemTeal)
                }
                
                NavigationLink(
                    destination: AllFeedstockList(for: factory)
                ) {
                    ListRow(
                        title: "Feedstocks",
                        subtitle: "TBD: .................",
                        detail: "TBD: some extra top-level details(?)",
                        icon: "cart"
                    )
                    .foregroundColor(.systemPurple)
                }
                
                NavigationLink(
                    destination: PackagingList(for: factory)
                ) {
                    ListRow(
                        title: "Packaging",
                        subtitle: "TBD: .................",
                        detail: "TBD: List of packaging types (??)",
                        icon: "shippingbox"
                    )
                    .foregroundColor(.systemIndigo)
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
                    LabelWithDetail("creditcard.fill", "Total revenue, ex VAT", factory.revenueExVAT.formattedGrouped)
                        .foregroundColor(.systemGreen)
                }
                
                NavigationLink(
                    destination: AllBuyersList(for: factory)
                ) {
                    LabelWithDetail("cart.fill", "All Buyers", "")
                }
                .foregroundColor(.systemPurple)
            }
            .font(.subheadline)
        }
    }
}
