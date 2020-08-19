//
//  RecipeEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct RecipeEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let recipeToEdit: Recipe?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        recipeToEdit = nil
        
        _base = State(initialValue: nil)
        _ingredient = State(initialValue: nil)
        _qty = State(initialValue: 0)
        _coefficientToParentUnit = State(initialValue: 1)
        
        title = "New Recipe"
    }
    
    init(_ recipe: Recipe) {
        _isPresented = .constant(true)
        
        recipeToEdit = recipe
        
        _base = State(initialValue: recipe.base)
        _ingredient = State(initialValue: recipe.ingredient)
        _qty = State(initialValue: recipe.qty)
        _coefficientToParentUnit = State(initialValue: recipe.coefficientToParentUnit)
        
        title = "Edit Recipe"
    }
    
    @State private var base: Base?
    @State private var ingredient: Ingredient?
    @State private var qty: Double
    @State private var coefficientToParentUnit: Double
    
    var body: some View {
        List {
            Section(
                header: Text("Ingredient")
            ) {
                EntityPicker(selection: $ingredient, icon: Ingredient.icon)
                
                AmountPicker(systemName: "square", title: "Ingredient Qty", navigationTitle: "Ingredient Qty", scale: .small, amount: $qty)
                    .foregroundColor(qty > 0 ? .accentColor : .systemRed)
                
                ChildUnitStringPicker(coefficientToParentUnit: $coefficientToParentUnit, parentUnit: ingredient?.customUnit)

                
                HStack {
                    Label("Unit", systemImage: "rectangle.3.offgrid")
                    
                    Spacer()
                    
                    ChildUnitStringPicker(coefficientToParentUnit: $coefficientToParentUnit, parentUnit: ingredient?.customUnit)
                }
                .foregroundColor(.accentColor)
            }
            
            Section(
                header: Text("Base product")
            ) {
                EntityPicker(selection: $base, icon: Base.icon, predicate: nil)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let recipe: Recipe
                    if let recipeToEdit = recipeToEdit {
                        recipe = recipeToEdit
                    } else {
                        recipe = Recipe(context: context)
                    }
                    
                    recipe.base = base
                    recipe.ingredient = ingredient
                    recipe.qty = qty
                    recipe.coefficientToParentUnit = coefficientToParentUnit
                    
                    context.saveContext()
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(base == nil || ingredient == nil || qty == 0)
            }
        }
    }
}
