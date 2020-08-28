//
//  Testing.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct Testing: View {
    @State var period: Period = .month()
    
    var body: some View {
        List {
            PeriodPicker(icon: "deskclock", title: "Period", period: $period)
            
            Section {
                NavigationLink(
                    destination: FactoryList(period: period)
                ) {
                    Text("Factories")
                }
                
                EntityLinkToList { (factory: Factory) in
                    FactoryView(factory, in: period)
                }
            }
            
            Section(
                //header: Text(""),
                footer: Text("Using View + Editor (via View).")
                
            ) {
                EntityLinkToList { (division: Division) in
                    DivisionView(division, in: period)
                }
                
                EntityLinkToList { (department: Department) in
                    DepartmentView(department, in: period)
                }
                
                EntityLinkToList { (buyer: Buyer) in
                    BuyerView(buyer)
                }
                
                EntityLinkToList { (product: Product) in
                    ProductView(product, in: period)
                }
                
                EntityLinkToList { (base: Base) in
                    BaseView(base, in: period)
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
                    IngredientView(ingredient, in: period)
                }
                
                EntityLinkToList { (packaging: Packaging) in
                    PackagingView(packaging, in: period)
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
        .navigationBarItems(trailing: CreateEntityPickerButton(period: Period.month()))
    }
}
