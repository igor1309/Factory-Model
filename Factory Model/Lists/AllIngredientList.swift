//
//  AllIngredientList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI
import CoreData

struct AllIngredientList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            for: factory,
            predicate: Ingredient.factoryPredicate(for: factory)
        ) {
            //  MARK: - FINISH THIS FUGURE OUT HOW TO CREATE ENTITY HERE
            EmptyView()
           /* CreateChildButton(
                systemName: "plus.square",
                childType: Ingredient.self,
                parent: factory,
                keyPath: \Factory.ingredients_
            ) */
        } dashboard: {
            Text("TBD: dashboard")
                .font(.subheadline)
        } editor: { (ingredient: Ingredient) in
            IngredientView(ingredient)
        }
    }
}
