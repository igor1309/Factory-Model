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
    
    @ObservedObject var factory: Factory
    
    init(_ factory: Factory) {
        self.factory = factory
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
            Section(header: Text("Products")) {
                NavigationLink(
                    destination: ProductList(for: factory)
                ) {
                    LabelWithDetail("bag", "Production", "TBD")
                }
                .font(.subheadline)
                
                NavigationLink(
                    destination: AllFeedstockList(for: factory)
                ) {
                    LabelWithDetail("puzzlepiece", "Feedstocks", factory.totalFeedstockCost.formattedGrouped)
                }
                .font(.subheadline)
                
                NavigationLink(
                    destination: AllFeedstockListTESTING(for: factory)
                ) {
                    LabelWithDetail("puzzlepiece", "TESTING!! Total Feedstocks", "TBD")
                }
                .font(.subheadline)
                .foregroundColor(.orange)
            }
            
            Section(
                header: Text("Sales")
            ) {
                NavigationLink(
                    destination: AllSalesList(for: factory)
                ) {
                    LabelWithDetail("cart", "Total revenue, ex VAT", factory.revenueExVAT.formattedGrouped)
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
            
            Section(header: Text("Factory Details")) {
                Group {
                    TextField("Name", text: $factory.name)
                    TextField("Note", text: $factory.note)
                }
                .foregroundColor(.accentColor)
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
