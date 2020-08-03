//
//  IngredientView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct IngredientView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var ingredient: Ingredient
    
    init(_ ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    var body: some View {
        
        List {
            Section(
                header: Text("Ingredient Detail")
            ) {
                EntityPicker(selection: $ingredient.feedstock, icon: Feedstock.icon, predicate: nil)
                
                AmountPicker(title: "Qty", navigationTitle: "Select Qty", scale: .large, amount: $ingredient.qty)
            }
            
            
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(ingredient.title)
    }
}
