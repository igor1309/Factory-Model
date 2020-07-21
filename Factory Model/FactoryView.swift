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
        _products = FetchRequest(entity: Product.entity(),
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
            Section(header: Text("Factory".uppercased())) {
                TextField("Name", text: $draft.name)
                TextField("Note", text: $draft.note)
            }
            
            Section(header: Text("Product Groups".uppercased())) {
                ForEach(factory.productGroups) { productGroup in
                    NavigationLink(
                        destination: ProductList(group: productGroup.title, at: factory)
                    ) {
                        ListRow(productGroup)
                    }
                }
                
                Group {
                    HStack {
                        Label("Total production", systemImage: "wrench.and.screwdriver")
                        Spacer()
                        Text("TBD")
                    }
                    
                    HStack {
                        Label("Total revenue, ex VAT", systemImage: "cart")
                        Spacer()
                        Text("\(factory.revenueExVAT, specifier: "%.f")")
                    }
                }
                .font(.subheadline)
                .padding(.vertical, 3)
                
//                Button("Add Product") {
//                    let product = Product(context: managedObjectContext)
//                    product.name = "New Product"
//                    product.note = "Some note for product"
//                    product.code = "1001"
//                    product.group = "Group1"
//                    factory.addToProducts_(product)
//                    save()
//                }
            }
            
            Section(header: Text("Staff: Divisions".uppercased())) {
                ForEach(factory.divisions) { division in
                    NavigationLink(
                        destination: StaffList(division: division.title, at: factory)
                    ) {
                        ListRow(division)
                    }
                }
                
                HStack {
                    Label("Total salary, incl taxes", systemImage: "person.2")
                    Spacer()
                    Text("TBD")
                }
                .font(.subheadline)
                
                Button("Add Staff") {
                    let staff = Staff(context: managedObjectContext)
                    staff.name = "New Staff"
                    staff.note = "Some note regarding new staff"
                    staff.division = "Main"
                    staff.department = "Production"
                    staff.position = "Worker"
                    staff.name = "John"
                    factory.addToStaff_(staff)
                    save()
                }
            }
            
            Section(header: Text("Expenses".uppercased())) {
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
            
            Section(header: Text("Equipment".uppercased())) {
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
        .navigationBarItems(trailing: saveButton)
    }
    
    private func removeProduct(at offsets: IndexSet) {
        for index in offsets {
            let product = factory.products[index]
            managedObjectContext.delete(product)
        }
        
        save()
    }
    
    private func removeEquipment(at offsets: IndexSet) {
        for index in offsets {
            let equipment = factory.equipment[index]
            managedObjectContext.delete(equipment)
        }
        
        save()
    }
    
    private func removeStaff(at offsets: IndexSet) {
        for index in offsets {
            let staff = factory.staff[index]
            managedObjectContext.delete(staff)
        }
        
        save()
    }
    
    private func removeExpenses(at offsets: IndexSet) {
        for index in offsets {
            let expenses = factory.expenses[index]
            managedObjectContext.delete(expenses)
        }
        
        save()
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
