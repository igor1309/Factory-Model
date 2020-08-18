//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct CreateNewEntityButton<T: Listable>: View where T.ManagedType == T {
    
    @Binding var isPresented: Bool
    
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
//            case Base.entityName:       BaseEditor(isPresented: $isPresented)
//            case Buyer.entityName:      BuyerView(isPresented: $isPresented)
//            case Department.entityName: DepartmentView(isPresented: $isPresented)
//            case Division.entityName:   DivisionView(isPresented: $isPresented)
//            case Equipment.entityName:  EquipmentView(isPresented: $isPresented)
//            case Employee.entityName:   EmployeeView(isPresented: $isPresented)
//            case Expenses.entityName:   ExpensesView(isPresented: $isPresented)
//            case Factory.entityName:    FactoryView(isPresented: $isPresented)
            case Ingredient.entityName: IngredientEditor(isPresented: $isPresented)
            case Packaging.entityName:  PackagingEditor(isPresented: $isPresented)
//            case Product.entityName:    ProductView(isPresented: $isPresented)
            case Recipe.entityName:     RecipeCreator(isPresented: $isPresented)
//            case Sales.entityName:      SalesView(isPresented: $isPresented)
//            case Utility.entityName:    UtilityView(isPresented: $isPresented)
            default: Text("TBD")
        }
    }
}
