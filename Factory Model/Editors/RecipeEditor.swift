//
//  RecipeEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct RecipeEditor: View {
    @Binding var base: Base?
    @Binding var ingredient: Ingredient?
    @Binding var qty: Double
    @Binding var coefficientToParentUnit: Double
    
    var body: some View {
        Text("NOT FINISHED")
            .foregroundColor(.systemRed)
            .font(.largeTitle)
        
        Section(
            header: Text("Base product")
        ) {
            EntityPicker(selection: $base, icon: Base.icon, predicate: nil)
        }
        
        HStack {
            EntityPicker(selection: $ingredient, icon: Ingredient.icon)
                .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            AmountPicker(navigationTitle: "Qty", scale: .small, amount: $qty)
                .buttonStyle(PlainButtonStyle())
            
//            ChildUnitPicker(entity)
            ChildUnitStringPicker(coefficientToParentUnit: $coefficientToParentUnit, parentUnit: ingredient?.customUnit)
            
        }
        .foregroundColor(.accentColor)
        
        //            RecipeUnitPicker(entity)
        
        
    }
}
