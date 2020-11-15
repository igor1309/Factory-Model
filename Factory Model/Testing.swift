//
//  Testing.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI
import CoreData

struct Testing: View {
    @EnvironmentObject var persistence: PersistenceManager
    @EnvironmentObject var settings: Settings
    
    @FetchRequest(entity: Product.entity(), sortDescriptors: [], predicate: NSPredicate(format: "name_ == %@", "Ведёрко 1 кг")) private var products: FetchedResults<Product>
    
    var body: some View {
        List {
            PeriodPicker(period: $settings.period)
            
            Section {
                if let product = products.first {
                    NavigationLink(destination: ProductView(product)) {
                        ListRow(product, period: settings.period)
                    }
                } else {
                    Text("can't fetch product")
                }
            }
            
            Section {
                NavigationLink(destination: FactoryList()) {
                    Text("Factories")
                }
                
                EntityLinkToList { (factory: Factory) in
                    FactoryView(factory)
                }
            }
            
            Section(
                header: Text("Main Entities"),
                footer: Text("Using View + Editor (via View).")
                
            ) {
                EntityLinkToList { (division: Division) in
                    DivisionView(division)
                }
                EntityLinkToList { (department: Department) in
                    DepartmentView(department)
                }
                EntityLinkToList { (buyer: Buyer) in
                    BuyerEditor(buyer)
                }
                EntityLinkToList { (product: Product) in
                    ProductView(product)
                }
                EntityLinkToList { (base: Base) in
                    BaseEditor(base)
                }
            }
            
            Section(
                header: Text("Many-to-many"),
                footer: Text("Subordinate. Not intended for direct use. No Entity View, using just Editor.")
            ) {
                EntityLinkToList { (sales: Sales) in
                    SalesEditor(sales)
                }
                EntityLinkToList { (recipe: Recipe) in
                    RecipeEditor(recipe)
                }
            }
            
            Section(
                header: Text("Many parents"),
                footer: Text("Using View + Editor (via View).")
            ) {
                EntityLinkToList { (ingredient: Ingredient) in
                    IngredientView(ingredient)
                }
                EntityLinkToList { (packaging: Packaging) in
                    PackagingEditor(packaging)
                }
            }
            
            Section(
                header: Text("One parent"),
                footer: Text("No Entity View, using Editor.")
            ) {
                EntityLinkToList { (utility: Utility) in
                    UtilityEditor(utility)
                }
                EntityLinkToList { (employee: Employee) in
                    EmployeeEditor(employee)
                }
                EntityLinkToList { (equipment: Equipment) in
                    //EquipmentView(equipment)
                    EquipmentEditor(equipment)
                }
                EntityLinkToList { (expenses: Expenses) in
                    ExpensesEditor(expenses)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Testing", displayMode: .inline)
        .navigationBarItems(
            leading: settingsButton,
            trailing: CreateEntityPickerButton()
        )
    }
    
    @State private var showSettings = false
    
    private var settingsButton: some View {
        Button {
            showSettings = true
        } label: {
            Image(systemName: "gear")
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(persistence)
                .environmentObject(settings)
        }
    }
}

struct Testing_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Testing()
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(PersistenceManager.preview)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 1250))
    }
}
