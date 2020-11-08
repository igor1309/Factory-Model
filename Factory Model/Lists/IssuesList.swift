//
//  IssuesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct IssuesList: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            //  MARK: - FINISH THIS hasIssues does not work - need to use fetch
            
            Group {
                //            if factory.basesHasIssues {
                GenericListSection(
                    type: Base.self,
                    predicate: Base.orphanPredicate
                ) { (base: Base) in
                    BaseView(base)
                }
                //            }
                //            if factory.buyersHasIssues {
                GenericListSection(
                    type: Buyer.self,
                    predicate: Buyer.orphanPredicate
                ) { (buyer: Buyer) in
                    BuyerEditor(buyer)
                }
                //            }
                //            if factory.departmentsHasIssues {
                GenericListSection(
                    type: Department.self,
                    predicate: Department.orphanPredicate
                ) { (department: Department) in
                    DepartmentView(department)
                }
                //            }
                
                //                if factory.departmentsHasIssues {
                GenericListSection(
                    type: Division.self,
                    predicate: Division.orphanPredicate
                ) { (division: Division) in
                    DivisionView(division)
                }
                //                }
                
                //            if factory.equipmentsHasIssues {
                GenericListSection(
                    type: Equipment.self,
                    predicate: Equipment.orphanPredicate
                ) { (equipment: Equipment) in
                    //EquipmentView(equipment)
                    EquipmentEditor(equipment)
                }
                //            }
                
                //            if factory.expensesHasIssues {
                GenericListSection(
                    type: Expenses.self,
                    predicate: Expenses.orphanPredicate
                ) { (expenses: Expenses) in
                    ExpensesEditor(expenses)
                }
                //            }
                
                //            if factory.ingredientsHasIssues {
                GenericListSection(
                    type: Ingredient.self,
                    predicate: Ingredient.orphanPredicate
                ) { (ingredient: Ingredient) in
                    IngredientView(ingredient)
                }
                //            }
            }
            
            Group {
                //            if factory.recipesHasIssues {
                GenericListSection(
                    type: Recipe.self,
                    predicate: Recipe.orphanPredicate
                ) { (recipe: Recipe) in
                    RecipeEditor(recipe)
                }
                //            }
                
                //            if factory.packagingsHasIssues {
                GenericListSection(
                    type: Packaging.self,
                    predicate: Packaging.orphanPredicate
                ) { (packaging: Packaging) in
                    PackagingEditor(packaging)
                }
                //            }
                
                //            if factory.packagingsHasIssues {
                GenericListSection(
                    type: Product.self,
                    predicate: Product.orphanPredicate
                ) { (product: Product) in
                    ProductView(product)
                }
                //            }
                //            if factory.salesHasIssues {
                GenericListSection(
                    type: Sales.self,
                    predicate: Sales.orphanPredicate
                ) { (sales: Sales) in
                    SalesEditor(sales)
                }
                //            }
                
                //            if factory.utilitiesHasIssues {
                GenericListSection(
                    type: Utility.self,
                    predicate: Utility.orphanPredicate
                ) { (utility: Utility) in
                    UtilityEditor(utility)
                }
                //            }
                
                //            if factory.employeesHasIssues {
                GenericListSection(
                    type: Employee.self,
                    predicate: Employee.orphanPredicate
                ) { (employee: Employee) in
                    EmployeeEditor(employee)
                }
                //            }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Issues")
    }
}

struct IssuesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IssuesList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
