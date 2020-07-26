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
    
//    @FetchRequest private var bases: FetchedResults<Base>
    
    @ObservedObject var factory: Factory
    
    init(_ factory: Factory) {
        self.factory = factory
//        _bases = FetchRequest(
//            entity: Base.entity(),
//            sortDescriptors: [
//                NSSortDescriptor(keyPath: \Base.name_, ascending: true)
//            ],
//            predicate: NSPredicate(
//                format: "%K == %@", #keyPath(Base.factory), factory
//            )
//        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Production")) {
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
                        destination: BaseList(for: factory)
                    ) {
                        ListRow(
                            title: "Base Products",
                            subtitle: ".................",
                            detail: "TBD: Base products with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)",
                            icon: "bag.circle"
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
                .font(.subheadline)
            }
            .foregroundColor(.systemOrange)

            Section(
                header: Text("Sales")
            ) {
                NavigationLink(
                    destination: AllSalesList(for: factory)
                ) {
                    LabelWithDetail("creditcard.fill", "Total revenue, ex VAT", factory.revenueExVAT.formattedGrouped)
                        .foregroundColor(.systemGreen)
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Expenses")) {
                NavigationLink(
                    destination: StaffList(at: factory)
                ) {
                    LabelWithDetail("person.2", "Salary, incl taxes", "TBD")
                        .font(.subheadline)
                }
                
                NavigationLink(
                    destination: ExpensesList(at: factory)
                ) {
                    LabelWithDetail("dollarsign.circle", "Other Expenses", "TBD")
                        .font(.subheadline)
                }
            }
            
            Section(header: Text("Equipment")) {
                Group {
                    NavigationLink(
                        destination: EquipmentList(at: factory)
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
                        destination: Text("Baseion TBD")
                    ) {
                        LabelWithDetail("bag.fill.badge.plus", "Baseion", "TBD")
                    }
                    
                    NavigationLink(
                        destination: AllFeedstockList(for: factory)
                    ) {
                        LabelWithDetail("puzzlepiece", "Feedstocks", factory.totalFeedstockCostExVAT.formattedGrouped)
                    }
                }
                .font(.subheadline)
            }
            
            Section(header: Text("TESTING")) {
                NavigationLink(
                    destination: AllFeedstockListTESTING(for: factory)
                ) {
                    LabelWithDetail("puzzlepiece", "TESTING!! Total Feedstocks", "TBD")
                }
                .font(.subheadline)
            }
            .foregroundColor(.orange)
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

struct FactoryView_Previews: PreviewProvider {
    static var previews: some View {
        FactoryView(Factory())
    }
}
