//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct CreateNewEntityButton<T: Listable>: View where T.ManagedType == T {
    
    var iconOnly: Bool = false
    
    @Binding var isPresented: Bool
    
    @State private var isActive = false
    
    private var navigationLink: some View {
        NavigationLink(
            destination: destination(),
            isActive: $isActive
        ) {
            Button {
                isActive = true
            } label: {
                if iconOnly {
                    Image(systemName: T.plusButtonIcon)
                } else {
                    Text("Create \(T.entityName)")
                        .frame(maxWidth: .infinity)
                        .accentColor(.white)
                        .simpleCardify(cornerRadius: 6, background: T.color)
                }
            }
        }
    }
    
    var body: some View {
        if iconOnly {
            navigationLink
        } else {
            VStack(spacing: 16) {
                Image(systemName: T.icon)
                    .foregroundColor(T.color)
                    .font(.system(size: 52, weight: .ultraLight, design: .default))
                    .padding(.top, 6)
                
                Text(T.headline)
                    .font(.subheadline)
                
                navigationLink
            }
            .simpleCardify()
        }
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
            .navigationBarItems(trailing: CreateNewEntityButton<Utility>(iconOnly: true, isPresented: $isPresented))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
