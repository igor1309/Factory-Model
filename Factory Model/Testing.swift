//
//  Testing.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct Testing: View {
    @Binding var period: Period
    
    init(in period: Binding<Period>) {
        _period = period
    }
    
    var body: some View {
        List {
            PeriodPicker(icon: "deskclock", title: "Period", period: $period)
            
            Section {
                NavigationLink(
                    destination: FactoryList(in: $period)
                ) {
                    Text("Factories")
                }
                
                EntityLinkToList(in: period) { (factory: Factory) in
                    FactoryView(factory, in: $period)
                }
            }
            
            Section(
                //header: Text(""),
                footer: Text("Using View + Editor (via View).")
                
            ) {
                EntityLinkToList(in: period) { (division: Division) in
                    DivisionView(division, in: period)
                }
                
                EntityLinkToList(in: period) { (department: Department) in
                    DepartmentView(department, in: period)
                }
                
                EntityLinkToList(in: period) { (buyer: Buyer) in
                    BuyerView(buyer, in: period)
                }
                
                EntityLinkToList(in: period) { (product: Product) in
                    ProductView(product, in: period)
                }
                
                EntityLinkToList(in: period) { (base: Base) in
                    BaseView(base, in: period)
                }
            }
            
            Section(
                header: Text("Many-to-many"),
                footer: Text("Subordinate. Not intended to direct use. No Entity View, using Editor.")
            ) {
                EntityLinkToList(in: period) { (sales: Sales) in
                    SalesEditor(sales, in: period)
                }
                
                EntityLinkToList(in: period) { (recipe: Recipe) in
                    RecipeEditor(recipe, in: period)
                }
            }
            
            Section(
                header: Text("Many parents"),
                footer: Text("Using View + Editor (via View).")
            ) {
                EntityLinkToList(in: period) { (ingredient: Ingredient) in
                    IngredientView(ingredient, in: period)
                }
                
                EntityLinkToList(in: period) { (packaging: Packaging) in
                    PackagingView(packaging, in: period)
                }
            }
            
            Section(
                header: Text("One parent"),
                footer: Text("No Entity View, using Editor.")
            ) {
                EntityLinkToList(in: period) { (utility: Utility) in
                    UtilityEditor(utility, in: period)
                }
                
                EntityLinkToList(in: period) { (employee: Employee) in
                    EmployeeEditor(employee)
                }
                
                EntityLinkToList(in: period) { (equipment: Equipment) in
                    EquipmentEditor(equipment, in: period)
                }
                
                EntityLinkToList(in: period) { (expenses: Expenses) in
                    ExpensesEditor(expenses)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Testing")
        .navigationBarItems(trailing: CreateEntityPickerButton(period: Period.month()))
    }
}

struct Testing_Previews: PreviewProvider {
    @State static var period: Period = .month()
    
    static var previews: some View {
        NavigationView {
            Testing(in: $period)
        }
        .preferredColorScheme(.dark)
        .environment(\.managedObjectContext, PersistenceManager.preview)
    }
}
