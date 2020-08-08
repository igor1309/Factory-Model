//
//  RecipeEditorCore.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct RecipeEditorCore: View {
    @ObservedObject var recipe: Recipe
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        Section(
            header: Text("Base product")
        ) {
            EntityPicker(selection: $recipe.base, icon: Base.icon, predicate: nil)
                .font(.subheadline)
        }
        
        Section(
            header: Text("Ingredient")
        ) {
            Group {
                RecipeRow(recipe)
                                
                Group {
                    LabelWithDetail("dollarsign.circle", "Cost", recipe.cost.formattedGrouped)
                    
                    LabelWithDetail("square.grid.3x3.middleright.fill", "Coefficient", "\(recipe.coefficientToParentUnit)")
                }
                .foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Unit (\(recipe.customUnitString))")
        ) {
            Group {
                LabelWithDetail("recipe.unit", "\(recipe.parentUnitString)")
            }
        }
        
        ValidationMessage(recipe)
    }
}
