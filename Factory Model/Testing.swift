//
//  Testing.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct Testing: View {
    var body: some View {
        List {
            Section {
                NavigationLink(
                    destination: FactoryList()
                ) {
                    Text("Factories")
                }
                
                EntityLinkToList { (factory: Factory) in
                    FactoryView(factory)
                }
            }
            
            Section(
                //header: Text(""),
                footer: Text("Using View + Editor (via View).")
                
            ) {
                EntityLinkToList { (department: Department) in
                    DepartmentView(department)
                }
                
                EntityLinkToList { (buyer: Buyer) in
                    BuyerView(buyer)
                }
                
                EntityLinkToList { (product: Product) in
                    ProductView(product)
                }
                
                EntityLinkToList { (base: Base) in
                    BaseView(base)
                }
            }
            
            Section(
                header: Text("Many-to-many"),
                footer: Text("Subordinate. Not intended to direct use. No Entity View, using Editor.")
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
                    PackagingView(packaging)
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
                    EquipmentEditor(equipment)
                }
                
                EntityLinkToList { (expenses: Expenses) in
                    ExpensesEditor(expenses)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Testing")
        .navigationBarItems(trailing: CreateEntityPickerButton())
    }
}
