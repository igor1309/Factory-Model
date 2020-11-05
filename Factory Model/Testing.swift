//
//  Testing.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct Testing: View {
    @EnvironmentObject var settings: Settings
    
    //    init(in period: Binding<Period>) {
    //        _period = period
    //    }
    
    var body: some View {
        List {
            PeriodPicker(icon: "deskclock", title: "Period", period: $settings.period)
            
            Section {
                NavigationLink(
                    destination: FactoryList()
                ) {
                    Text("Factories")
                }
                
                EntityLinkToList { (factory: Factory) in
                    FactoryView(factory, in: $settings.period)
                }
            }
            
            Section(
                header: Text("Main Entities"),
                footer: Text("Using View + Editor (via View).")
                
            ) {
                EntityLinkToList { (division: Division) in
                    DivisionView(division, in: settings.period)
                }
                
                EntityLinkToList { (department: Department) in
                    DepartmentView(department, in: settings.period)
                }
                
                EntityLinkToList { (buyer: Buyer) in
                    BuyerView(buyer, in: settings.period)
                }
                
                EntityLinkToList { (product: Product) in
                    ProductView(product, in: settings.period)
                }
                
                EntityLinkToList { (base: Base) in
                    BaseView(base, in: settings.period)
                }
            }
            
            Section(
                header: Text("Many-to-many"),
                footer: Text("Subordinate. Not intended for direct use. No Entity View, using just Editor.")
            ) {
                EntityLinkToList { (sales: Sales) in
                    SalesEditor(sales, in: settings.period)
                }
                
                EntityLinkToList { (recipe: Recipe) in
                    RecipeEditor(recipe, in: settings.period)
                }
            }
            
            Section(
                header: Text("Many parents"),
                footer: Text("Using View + Editor (via View).")
            ) {
                EntityLinkToList { (ingredient: Ingredient) in
                    IngredientView(ingredient, in: settings.period)
                }
                
                EntityLinkToList { (packaging: Packaging) in
                    PackagingView(packaging, in: settings.period)
                }
            }
            
            Section(
                header: Text("One parent"),
                footer: Text("No Entity View, using Editor.")
            ) {
                EntityLinkToList { (utility: Utility) in
                    UtilityEditor(utility, in: settings.period)
                }
                
                EntityLinkToList { (employee: Employee) in
                    EmployeeEditor(employee)
                }
                
                EntityLinkToList { (equipment: Equipment) in
                    EquipmentEditor(equipment, in: settings.period)
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
            trailing: CreateEntityPickerButton(period: Period.month())
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                settingsButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                CreateEntityPickerButton(period: Period.month())
            }
        }
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
                .environmentObject(settings)
        }
    }
}

struct Testing_Previews: PreviewProvider {
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        NavigationView {
            Testing()
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(settings)
        .preferredColorScheme(.dark)
    }
}
