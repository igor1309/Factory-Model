//
//  IngredientEditorCore.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct IngredientEditorCore: View {
    @ObservedObject var ingredient: Ingredient
    
    init(_ ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    var body: some View {
        Section(
            header: Text("Base product")
        ) {
            EntityPicker(selection: $ingredient.base, icon: Base.icon, predicate: nil)
        }
        
        Section(
            header: Text("Feedstock")
        ) {
            EntityPicker(selection: $ingredient.feedstock, icon: Feedstock.icon, predicate: nil)
                .font(.subheadline)
        }
        
        Section(
            header: Text("Ingredient Qty")
        ) {
            AmountPicker(systemName: "square", title: "Ingredient Qty", navigationTitle: "Qty", scale: .small, amount: $ingredient.qty)
                .font(.subheadline)
            
        }
    }
}
