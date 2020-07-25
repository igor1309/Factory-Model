//
//  FactoryView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import SwiftPI

struct FactoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
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
//                format: "factory = %@", factory
//            )
//        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Baseion")) {
                Group {
                    NavigationLink(
                        destination: BaseList(for: factory)
                    ) {
                        ListRow(
                            title: "Bases",
                            subtitle: "Baseion",
                            detail: "",
                            icon: "bag"
                        )
                    }
                    
                    NavigationLink(
                        destination: PackagingList(for: factory)
                    ) {
                        ListRow(
                            title: "Packaging",
                            subtitle: "Packaged Bases",
                            detail: "",
                            icon: "bag.circle"
                        )
                    }
                    
                    NavigationLink(
                        destination: Text("TBD")
                    ) {
                        ListRow(
                            title: "Procurement",
                            subtitle: "Feedstocks and Packaging Materials",
                            detail: "",
                            icon: "cart"
                        )
                    }
                }
                .font(.subheadline)
            }

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
                    LabelWithDetail("person.2", "Salary, incl taxes", factory.totalSalaryWithTax.formattedGrouped)
                        .font(.subheadline)
                }
                
                NavigationLink(
                    destination: ExpensesList(at: factory)
                ) {
                    LabelWithDetail("dollarsign.circle", "Other Expenses", factory.expensesTotal.formattedGrouped)
                        .font(.subheadline)
                }
            }
            
            Section(header: Text("Equipment")) {
                NavigationLink(
                    destination: EquipmentList(at: factory)
                ) {
                    LabelWithDetail("wrench.and.screwdriver", "Total Equipment", factory.equipmentTotal.formattedGrouped)
                        .font(.subheadline)
                }
            }
            
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
                        destination: PackagingList(for: factory)
                    ) {
                        LabelWithDetail("bag.circle", "Packaging/Bases", "TBD")
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
            managedObjectContext.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

struct FactoryView_Previews: PreviewProvider {
    static var previews: some View {
        FactoryView(Factory())
    }
}
