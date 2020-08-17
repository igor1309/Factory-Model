//
//  RecipeCreator.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct RecipeCreator: View {
    @Environment(\.managedObjectContext) private var context
    
    @Binding var isPresented: Bool
    
    @State private var base: Base?
    @State private var ingredient: Ingredient?
    @State private var qty: Double = 0
    @State private var coefficientToParentUnit: Double = 1
    
    var body: some View {
        List {
            RecipeEditor(base: $base, ingredient: $ingredient, qty: $qty, coefficientToParentUnit: $coefficientToParentUnit)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("New recipe")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let recipe = Recipe(context: context)
                    recipe.base = base
                    recipe.ingredient = ingredient
                    recipe.qty = qty
                    recipe.coefficientToParentUnit = coefficientToParentUnit
                    
                    context.saveContext()
                    isPresented = false
                }
                .disabled(base == nil || ingredient == nil || qty <= 0)
            }
        }
    }
}
