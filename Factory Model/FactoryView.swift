//
//  FactoryView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

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
                Group {
                    NavigationLink(
                        destination: ProductList(for: factory)
                    ) {
                        HStack {
                            Label("Total production", systemImage: "wrench.and.screwdriver")
                            Spacer()
                            Text("TBD")
                        }
                    }
                }
                .font(.subheadline)
                .padding(.vertical, 3)
            }
            
            Section(
                header: Text("Sales"),
                footer: Text("To edit Sales go to Product")
            ) {
                NavigationLink(
                    destination: AllSalesList(for: factory)
                ) {
                    HStack {
                        Label("Total revenue, ex VAT", systemImage: "cart")
                        Spacer()
                        Text("\(factory.revenueExVAT, specifier: "%.f")")
                    }
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Staff")) {
                NavigationLink(
                    destination: StaffList(at: factory)
                ) {
                    HStack {
                        Label("Total salary, incl taxes", systemImage: "person.2")
                        Spacer()
                        
                        Text("\(factory.totalSalaryWithTax, specifier: "%.f")")
                    }
                    .font(.subheadline)
                }
            }
            
            Section(header: Text("Expenses")) {
                NavigationLink(
                    destination: ExpensesList(at: factory)
                ) {
                    HStack {
                        Label("Total Expenses", systemImage: "dollarsign.circle")
                        Spacer()
                        Text("\(factory.expensesTotal, specifier: "%.f")")
                    }
                    .font(.subheadline)
                }
            }
            
            Section(header: Text("Equipment")) {
                NavigationLink(
                    destination: EquipmentList(at: factory)
                ) {
                    HStack {
                        Label("Total Equipment", systemImage: "wrench.and.screwdriver")
                        Spacer()
                        Text("\(factory.equipmentTotal, specifier: "%.f")")
                    }
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
            //  MARK: FINISH THIS
            
            save()
            presentation.wrappedValue.dismiss()
        }
    }
    
    private func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // handle the Core Data error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

struct FactoryView_Previews: PreviewProvider {
    static var previews: some View {
        FactoryView(Factory())
    }
}
