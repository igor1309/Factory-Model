//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct CreateNewEntityButton<T: Listable>: View where T.ManagedType == T {
    
    @Binding var isPresented: Bool
    
    let period: Period
    
    @State private var isActive = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: T.icon)
                .foregroundColor(T.color)
                .font(.system(size: 52, weight: .ultraLight, design: .default))
            
            Text(T.headline)
                .font(.subheadline)
            
            NavigationLink(
                destination: destination(),
                isActive: $isActive
            ) {
                Button {
                    isActive = true
                } label: {
                    Text("Create \(T.entityName)")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .simpleCardify(cornerRadius: 6, background: T.color)
                }
            }
        }
        .simpleCardify()
    }
    
    @ViewBuilder
    private func destination() -> some View {
        switch T.entityName {
            case Base.entityName:       BaseEditor(isPresented: $isPresented, in: period)
            case Buyer.entityName:      BuyerEditor(isPresented: $isPresented, in: period)
            case Department.entityName: DepartmentEditor(isPresented: $isPresented, in: period)
            case Division.entityName:   DivisionEditor(isPresented: $isPresented, in: period)
            case Equipment.entityName:  EquipmentEditor(isPresented: $isPresented, in: period)
            case Employee.entityName:   EmployeeEditor(isPresented: $isPresented, in: period)
            case Expenses.entityName:   ExpensesEditor(isPresented: $isPresented, in: period)
            case Factory.entityName:    FactoryEditor(isPresented: $isPresented)
            case Ingredient.entityName: IngredientEditor(isPresented: $isPresented)
            case Packaging.entityName:  PackagingEditor(isPresented: $isPresented, in: period)
            case Product.entityName:    ProductEditor(isPresented: $isPresented, in: period)
            case Recipe.entityName:     RecipeEditor(isPresented: $isPresented, in: period)
            case Sales.entityName:      SalesEditor(isPresented: $isPresented, in: period)
            case Utility.entityName:    UtilityEditor(isPresented: $isPresented, in: period)
            default: Text("TBD")
        }
    }
}
