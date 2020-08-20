//
//  Testing.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct Testing: View {
    var body: some View {
        NavigationView {
            List {
                EntityLinkToList { (factory: Factory) in
                    FactoryEditor(factory)
                }
                
                Section(
                    header: Text("Many parents"),
                    footer: Text("Using View + Editor.")
                ) {
                    EntityLinkToList { (ingredient: Ingredient) in
                        IngredientView(ingredient)
                    }
                    
                    EntityLinkToList { (ingredient: Ingredient) in
                        IngredientEditor(ingredient)
                    }
                    
                    EntityLinkToList { (packaging: Packaging) in
                        PackagingView(packaging)
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
                        EquipmentEditor(equipment)
                    }
                    
                    EntityLinkToList { (expenses: Expenses) in
                        ExpensesEditor(expenses)
                    }
                }
                
                Section {
                    EntityLinkToList { (product: Product) in
                        ProductEditor(product)
                    }
                    
                    EntityLinkToList { (buyer: Buyer) in
                        BuyerEditor(buyer)
                    }
                    
                    EntityLinkToList { (department: Department) in
                        DepartmentEditor(department)
                    }
                    
                    EntityLinkToList { (base: Base) in
                        BaseView(base)
                    }
                }
                
                Section(
                    header: Text("Many-to-many"),
                    footer: Text("Secondary.")
                ) {
                    EntityLinkToList { (sales: Sales) in
                        SalesEditor(sales)
                    }
                    
                    EntityLinkToList { (sales: Sales) in
                        SalesView(sales)
                    }
                    
                    EntityLinkToList { (recipe: Recipe) in
                        List {
                            RecipeEditorCore(recipe)
                        }
                        .listStyle(InsetGroupedListStyle())
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    
                    EntityLinkToList { (recipe: Recipe) in
                        RecipeEditor(recipe)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Testing")
            .navigationBarItems(trailing: CreateEntityPickerButton())
        }
    }
}
