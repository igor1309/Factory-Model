//
//  RecipeView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct RecipeView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var recipe: Recipe
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        
        List {
            Section(
                header: Text("Recipe Detail")
            ) {
                EntityPicker(selection: $recipe.ingredient, icon: Ingredient.icon, predicate: nil)
                
                AmountPicker(title: "Qty", navigationTitle: "Select Qty", scale: .large, amount: $recipe.qty)
            }
            
            
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(recipe.title)
    }
}
