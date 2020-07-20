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
                    ListRow(title: productGroup.title, subtitle: productGroup.subtitle, icon: "bag")
                }
            }
            
            Section(header: Text("Products".uppercased())) {
                ForEach(factory.products, id: \.self) { product in
                    NavigationLink(
                        destination: ProductView(product)
                    ) {
                        ListRow(title: product.name, subtitle: product.note, detail: product.group + ": " + product.code, icon: "bag")
                    }
                }
                .onDelete(perform: removeProduct)
                
                Button("Add Product") {
                    let product = Product(context: managedObjectContext)
                    product.name = "New Product"
                    product.note = "Some note for product"
                    product.code = "1001"
                    product.group = "Group1"
                    factory.addToProducts_(product)
                    save()
                }
            }
            
            Section(header: Text("Staff: Divisions".uppercased())) {
                ForEach(factory.divisions) { division in
                    ListRow(title: division.title, subtitle: division.subtitle, icon: "person.2")
                }
            }
            
            Section(header: Text("Staff".uppercased())) {
                ForEach(factory.staff, id: \.self) { staff in
                    ListRow(
                        title: staff.name,
                        subtitle: staff.note,
                        detail: staff.department + ": " + staff.division + ": " + staff.position,
                        icon: "person.2"
                    )
                }
                .onDelete(perform: removeStaff)
                
                Button("Add Staff") {
                    let staff = Staff(context: managedObjectContext)
                    staff.name = "New Staff"
                    staff.note = "Some note regarding new staff"
                    staff.department = "Production"
                    staff.division = "Main"
                    staff.position = "Worker"
                    staff.name = "John"
                    factory.addToStaff_(staff)
                    save()
                }
            }
            
            Section(header: Text("Expenses".uppercased())) {
                ForEach(factory.expenses.sorted(by: { $0.name < $1.name }), id: \.self) { expenses in
                    ListRow(title: expenses.name, subtitle: expenses.note, icon: "dollarsign.circle")
                }
                .onDelete(perform: removeExpenses)
                
                Button("Add Expenses") {
                    let expenses = Expenses(context: managedObjectContext)
                    expenses.name = "New Expenses"
                    expenses.note = "Some note regarding new expenses"
                    factory.addToExpenses_(expenses)
                    save()
                }
            }
            
            Section(header: Text("Equipment".uppercased())) {
                ForEach(factory.equipment.sorted(by: { $0.name < $1.name }), id: \.self) { equipment in
                    ListRow(title: equipment.name, subtitle: equipment.note, icon: "wrench.and.screwdriver")
                }
                .onDelete(perform: removeEquipment)
                
                Button("Add Equipment") {
                    let equipment = Equipment(context: managedObjectContext)
                    equipment.name = "New Equipment"
                    equipment.note = "Some note regarding new equipment"
                    factory.addToEquipment_(equipment)
                    save()
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
