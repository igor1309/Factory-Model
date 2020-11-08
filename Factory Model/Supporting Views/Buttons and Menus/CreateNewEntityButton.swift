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
                .padding(.top, 6)
            
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
                        .accentColor(.white)
                        .simpleCardify(cornerRadius: 6, background: T.color)
                }
            }
        }
        .simpleCardify()
    }
    
    @ViewBuilder
    private func destination() -> some View {
        switch T.entityName {
            case Base.entityName:       BaseEditor(isPresented: $isPresented)
            case Buyer.entityName:      BuyerEditor(isPresented: $isPresented)
            case Department.entityName: DepartmentEditor(isPresented: $isPresented)
            case Division.entityName:   DivisionEditor(isPresented: $isPresented)
            case Equipment.entityName:  EquipmentEditor(isPresented: $isPresented)
            case Employee.entityName:   EmployeeEditor(isPresented: $isPresented)
            case Expenses.entityName:   ExpensesEditor(isPresented: $isPresented)
            case Factory.entityName:    FactoryEditor(isPresented: $isPresented)
            case Ingredient.entityName: IngredientEditor(isPresented: $isPresented)
            case Packaging.entityName:  PackagingEditor(isPresented: $isPresented)
            case Product.entityName:    ProductEditor(isPresented: $isPresented)
            case Recipe.entityName:     RecipeEditor(isPresented: $isPresented)
            case Sales.entityName:      SalesEditor(isPresented: $isPresented)
            case Utility.entityName:    UtilityEditor(isPresented: $isPresented)
            default: Text("TBD")
        }
    }
}

struct CreateNewEntityButton_Previews: PreviewProvider {
    @State private static var isPresented = false
    
    static var previews: some View {
        NavigationView {
            ScrollView {
                CreateNewEntityButton<Base>(isPresented: $isPresented)
                CreateNewEntityButton<Packaging>(isPresented: $isPresented)
                CreateNewEntityButton<Utility>(isPresented: $isPresented)
            }
            .padding(.horizontal)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environment(\.colorScheme, .dark)
    }
}
