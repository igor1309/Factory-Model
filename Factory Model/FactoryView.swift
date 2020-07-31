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
            
            Group {
                
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
                    }
                    .font(.subheadline)
                }
                

                Section(
                    header: Text("Personnel")
                ) {
                    Group {
                        NavigationLink(
                            destination: AllWorkersList(for: factory)
                        ) {
                            ListRow(
                                title: "People (all)",
                                subtitle: "TBD: total headcount",
                                detail: "TBD: total salary",
                                icon: "person.2"
                            )
                        }
                    }
                    .foregroundColor(.systemIndigo)
                    .font(.subheadline)
                }
                
                Section(
                    header: Text("Packaging")
                ) {
                    Group {
                        NavigationLink(
                            destination: PackagingList(for: factory)
                        ) {
                            ListRow(
                                title: "Packaging",
                                subtitle: "TBD: .................",
                                detail: "TBD: List of packaging types (??)",
                                icon: "shippingbox"
                            )
                        }
                    }
                    .foregroundColor(.systemIndigo)
                    .font(.subheadline)
                }
                
                Section(
                    header: Text("Buyers")
                ) {
                    Group {
                        NavigationLink(
                            destination: AllBuyersList(for: factory)
                        ) {
                            LabelWithDetail("cart.fill", "All Buyers", "")
                        }
                    }
                    .foregroundColor(.systemPurple)
                    .font(.subheadline)
                }
                
                
                
                Group {
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
                    
                    Group {
                        NavigationLink(
                            destination: EquipmentList(for: factory)
                        ) {
                            //  MARK: more clever depreciation?
                            LabelWithDetail("wrench.and.screwdriver", "Salvage Value", "TBD")
                        }
                        
                        LabelWithDetail("wrench.and.screwdriver", "Cost basis", "TBD")
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                    }
                    .foregroundColor(.systemTeal)
                    .font(.subheadline)
                    .padding(.vertical, 3)
                    
                    
                    NavigationLink(
                        destination: ExpensesList(for: factory)
                    ) {
                        //  MARK: more clever depreciation?
                        LabelWithDetail("dollarsign.circle", "Other Expenses", "TBD")
                    }
                    .foregroundColor(.systemTeal)
                    .font(.subheadline)
                    .padding(.vertical, 3)
                }
            }
            
            Section(
                header: Text("Personnel")
            ) {
                NavigationLink(
                    destination: DivisionList(for: factory)
                ) {
                    ListRow(
                        title: "Divisions, [TBD: Total headcount]",
                        subtitle: "Budget, incl tax \(factory.totalSalaryWithTax.formattedGrouped)",
                        detail: factory.divisionNames,
                        icon: "person.crop.rectangle"
                    )
                }
                .foregroundColor(.systemTeal)
            }
            
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
                    }
                }
                .font(.subheadline)
            }
            .foregroundColor(.systemOrange)
            
            Section(
                header: Text("Expenses")
            ) {
                NavigationLink(
                    destination: ExpensesList(for: factory)
                ) {
                    LabelWithDetail("dollarsign.circle", "Other Expenses", "TBD")
                        .font(.subheadline)
                }
            }
            
            
            Section(header: Text("Equipment")) {
                Group {
                    NavigationLink(
                        destination: EquipmentList(for: factory)
                    ) {
                        //  MARK: more clever depreciation?
                        LabelWithDetail("wrench.and.screwdriver", "Salvage Value", "TBD")
                        
                    }
                    LabelWithDetail("wrench.and.screwdriver", "Cost basis", "TBD")
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                }
                .font(.subheadline)
            }
            .foregroundColor(.purple)
            
            Section(
                header: Text("Books")
            ) {
                NavigationLink(
                    destination: Text("TBD")
                ) {
                    ListRow(
                        title: "Reports",
                        subtitle: "",
                        detail: "",
                        icon: "books.vertical"
                    )
                }
            }
            .foregroundColor(.systemTeal)
            
            Section(header: Text("Factory Details")) {
                Group {
                    TextField("Name", text: $factory.name)
                    TextField("Note", text: $factory.note)
                }
                .foregroundColor(.accentColor)
            }
            
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
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(factory.name)
        .navigationBarTitleDisplayMode(.inline)
        //        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
