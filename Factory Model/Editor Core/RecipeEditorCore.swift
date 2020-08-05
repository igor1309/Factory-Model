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
    
    var unitHeader: some View {
        let text: String = {
            if let unit = recipe.unit {
                return "Unit (\(unit.symbol))"
            } else {
                return "Unit"
            }
        }()
        
        return Text(text)
    }
    
    var body: some View {
        Section(
            header: Text("Short version")
        ) {
            RecipeRow(recipe)
        }
        
        Section(
            header: Text("Base product")
        ) {
            EntityPicker(selection: $recipe.base, icon: Base.icon, predicate: nil)
        }
        
        Section(
            header: Text("Ingredient")
        ) {
            EntityPicker(selection: $recipe.ingredient, icon: Ingredient.icon, predicate: nil)
                .font(.subheadline)
        }
        
        Section(
            header: Text("Ingredient Qty")
        ) {
            AmountPicker(systemName: "square", title: "Ingredient Qty", navigationTitle: "Qty", scale: .small, amount: $recipe.qty)
                .font(.subheadline)
            
        }
        
        Section(
            header: unitHeader
        ) {
            Group {
                LabelWithDetail("recipe.unit", "\(recipe.unit == nil ? "Unit not defined" : recipe.unit!.symbol)")
                MassVolumeUnitPicker<Recipe>(unit: $recipe.unit)
                    .pickerStyle(SegmentedPickerStyle())
                
                Divider()
                MassVolumeUnitSubPicker(unit_: $recipe.unitSymbol_)
            }
        }
        
        Text(recipe.validationMessage)
            .foregroundColor(recipe.isValid ? .systemGreen : .systemRed)
    }
}
