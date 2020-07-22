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
    
    @FetchRequest var products: FetchedResults<Product>
    
    var factory: Factory
    
    @State private var draft: Factory
    
    init(_ factory: Factory) {
        self.factory = factory
        _draft = State(initialValue: factory)
        _products = FetchRequest(
            entity: Product.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Product.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@", factory
            )
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Factory")) {
                Group {
                    TextField("Name", text: $draft.name)
                    TextField("Note", text: $draft.note)
                }
                .foregroundColor(.accentColor)
            }
            
            Section(header: Text("Products")) {
                NavigationLink(
                    destination: ProductList(for: factory)
                ) {
                    LabelWithDetail("wrench.and.screwdriver", "Total production", "TBD")
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Feedstocks")) {
                NavigationLink(
                    destination: AllFeedstockList(for: factory)
                ) {
                    LabelWithDetail("puzzlepiece", "Total Feedstocks", "TBD")
                }
                .font(.subheadline)
            }
            
            Section(header: Text("TESTING!! Feedstocks")) {
                NavigationLink(
                    destination: AllFeedstockListTESTING(for: factory)
                ) {
                    LabelWithDetail("puzzlepiece", "TESTING!! Total Feedstocks", "TBD")
                }
                .font(.subheadline)
            }
            .foregroundColor(.orange)
            
            Section(
                header: Text("Sales"),
                footer: Text("To edit Sales go to Product")
            ) {
                NavigationLink(
                    destination: AllSalesList(for: factory)
                ) {
                    LabelWithDetail("cart", "Total revenue, ex VAT", factory.revenueExVAT.formattedGrouped)
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Staff")) {
                NavigationLink(
                    destination: StaffList(at: factory)
                ) {
                    LabelWithDetail("person.2", "Total salary, incl taxes", factory.totalSalaryWithTax.formattedGrouped)
                        .font(.subheadline)
                }
            }
            
            Section(header: Text("Expenses")) {
                NavigationLink(
                    destination: ExpensesList(at: factory)
                ) {
                    LabelWithDetail("dollarsign.circle", "Total Expenses", factory.expensesTotal.formattedGrouped)
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
