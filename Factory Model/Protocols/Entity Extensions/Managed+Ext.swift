//
//  Managed+Ext.swift
//  Factory Model
//
//  Created by Igor Malyarov on 10.11.2020.
//

import SwiftUI

extension Managed {
    
    @ViewBuilder
    static func creator(isPresented: Binding<Bool>) -> some View {
        switch entityName {
            case Base.entityName:       BaseEditor(isPresented: isPresented)
            case Buyer.entityName:      BuyerEditor(isPresented: isPresented)
            case Department.entityName: DepartmentEditor(isPresented: isPresented)
            case Division.entityName:   DivisionEditor(isPresented: isPresented)
            case Equipment.entityName:  EquipmentEditor(isPresented: isPresented)
            case Employee.entityName:   EmployeeEditor(isPresented: isPresented)
            case Expenses.entityName:   ExpensesEditor(isPresented: isPresented)
            case Factory.entityName:    FactoryEditor(isPresented: isPresented)
            case Ingredient.entityName: IngredientEditor(isPresented: isPresented)
            case Packaging.entityName:  PackagingEditor(isPresented: isPresented)
            case Product.entityName:    ProductEditor(isPresented: isPresented)
            case Recipe.entityName:     RecipeEditor(isPresented: isPresented)
            case Sales.entityName:      SalesEditor(isPresented: isPresented)
            case Utility.entityName:    UtilityEditor(isPresented: isPresented)
            default: Text("TBD")
        }
    }
    
    @ViewBuilder
    func viewer() -> some View {
        switch type(of: self).entityName {
            case Base.entityName:       BaseView(self as! Base)
            case Buyer.entityName:      BuyerView(self as! Buyer)
            case Department.entityName: DepartmentView(self as! Department)
            case Division.entityName:   DivisionView(self as! Division)
            case Equipment.entityName:  EquipmentEditor(self as! Equipment)
            case Employee.entityName:   EmployeeEditor(self as! Employee)
            case Expenses.entityName:   ExpensesEditor(self as! Expenses)
            case Factory.entityName:    FactoryView(self as! Factory)
            case Ingredient.entityName: IngredientView(self as! Ingredient)
            case Packaging.entityName:  PackagingView(self as! Packaging)
            case Product.entityName:    ProductView(self as! Product)
            case Recipe.entityName:     RecipeEditor(self as! Recipe)
            case Sales.entityName:      SalesEditor(self as! Sales)
            case Utility.entityName:    UtilityEditor(self as! Utility)
            default: Text("TBD")
        }
    }

    //    @ViewBuilder
//    func editor() -> some View {
//        switch type(of: self).entityName {
//            case Base.entityName:       BaseEditor(self as! Base)
//            case Buyer.entityName:      BuyerEditor(self as! Buyer)
//            case Department.entityName: DepartmentEditor(self as! Department)
//            case Division.entityName:   DivisionEditor(division: self as! Division)
//            case Equipment.entityName:  EquipmentEditor(self as! Equipment)
//            case Employee.entityName:   EmployeeEditor(self as! Employee)
//            case Expenses.entityName:   ExpensesEditor(self as! Expenses)
//            case Factory.entityName:    FactoryEditor(self as! Factory)
//            case Ingredient.entityName: IngredientEditor(self as! Ingredient)
//            case Packaging.entityName:  PackagingEditor(self as! Packaging)
//            case Product.entityName:    ProductEditor(self as! Product)
//            case Recipe.entityName:     RecipeEditor(self as! Recipe)
//            case Sales.entityName:      SalesEditor(self as! Sales)
//            case Utility.entityName:    UtilityEditor(self as! Utility)
//            default: Text("TBD")
//        }
//    }
}
