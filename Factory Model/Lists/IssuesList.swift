//
//  IssuesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI

struct IssuesList: View {
    
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        List {
            //  MARK: - FINISH THIS hasIssues does not work - need to use fetch
            
            Group {
                //            if factory.basesHasIssues {
                GenericListSection(
                    type: Base.self,
                    predicate: Base.orphanPredicate,
                    in: period
                ) { (base: Base) in
                    BaseView(base, in: period)
                }
                //            }
                //            if factory.buyersHasIssues {
                GenericListSection(
                    type: Buyer.self,
                    predicate: Buyer.orphanPredicate,
                    in: period
                ) { (buyer: Buyer) in
                    BuyerEditor(buyer, in: period)
                }
                //            }
                //            if factory.departmentsHasIssues {
                GenericListSection(
                    type: Department.self,
                    predicate: Department.orphanPredicate,
                    in: period
                ) { (department: Department) in
                    DepartmentView(department, in: period)
                }
                //            }
                
                //                if factory.departmentsHasIssues {
                GenericListSection(
                    type: Division.self,
                    predicate: Division.orphanPredicate,
                    in: period
                ) { (division: Division) in
                    DivisionView(division, in: period)
                }
                //                }
                
                //            if factory.equipmentsHasIssues {
                GenericListSection(
                    type: Equipment.self,
                    predicate: Equipment.orphanPredicate,
                    in: period
                ) { (equipment: Equipment) in
                    //EquipmentView(equipment)
                    EquipmentEditor(equipment, in: period)
                }
                //            }
                
                //            if factory.expensesHasIssues {
                GenericListSection(
                    type: Expenses.self,
                    predicate: Expenses.orphanPredicate,
                    in: period
                ) { (expenses: Expenses) in
                    ExpensesEditor(expenses, in: period)
                }
                //            }
                
                //            if factory.ingredientsHasIssues {
                GenericListSection(
                    type: Ingredient.self,
                    predicate: Ingredient.orphanPredicate,
                    in: period
                ) { (ingredient: Ingredient) in
                    IngredientView(ingredient, in: period)
                }
                //            }
            }
            
            Group {
                //            if factory.recipesHasIssues {
                GenericListSection(
                    type: Recipe.self,
                    predicate: Recipe.orphanPredicate,
                    in: period
                ) { (recipe: Recipe) in
                    RecipeEditor(recipe, in: period)
                }
                //            }
                
                //            if factory.packagingsHasIssues {
                GenericListSection(
                    type: Packaging.self,
                    predicate: Packaging.orphanPredicate,
                    in: period
                ) { (packaging: Packaging) in
                    PackagingEditor(packaging, in: period)
                }
                //            }
                
                //            if factory.packagingsHasIssues {
                GenericListSection(
                    type: Product.self,
                    predicate: Product.orphanPredicate,
                    in: period
                ) { (product: Product) in
                    ProductView(product, in: period)
                }
                //            }
                //            if factory.salesHasIssues {
                GenericListSection(
                    type: Sales.self,
                    predicate: Sales.orphanPredicate,
                    in: period
                ) { (sales: Sales) in
                    SalesEditor(sales, in: period)
                }
                //            }
                
                //            if factory.utilitiesHasIssues {
                GenericListSection(
                    type: Utility.self,
                    predicate: Utility.orphanPredicate,
                    in: period
                ) { (utility: Utility) in
                    UtilityEditor(utility, in: period)
                }
                //            }
                
                //            if factory.employeesHasIssues {
                GenericListSection(
                    type: Employee.self,
                    predicate: Employee.orphanPredicate,
                    in: period
                ) { (employee: Employee) in
                    EmployeeEditor(employee, in: period)
                }
                //            }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Issues")
    }
}
