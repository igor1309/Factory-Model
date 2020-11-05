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
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        ListWithDashboard(
            for: factory,
            predicate: Ingredient.factoryPredicate(for: factory),
            in: period
        ) {
            CreateOrphanButton<Ingredient>(systemName: Ingredient.plusButtonIcon)
        } dashboard: {
            Section(
                header: Text("Used in Production")
            ) {
                Group {
                    LabelWithDetail("squareshape.split.3x3", "No of Ingredients", factory.ingredients.count.formattedGrouped)
                    LabelWithDetail("dollarsign.circle", "Total Cost ex VAT", factory.produced(in: period).cost.ingredient.valueStr)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        } editor: { (ingredient: Ingredient) in
            IngredientView(ingredient, in: period)
        }
    }
}

struct AllIngredientList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllIngredientList(for: Factory.preview, in: .month())
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .preferredColorScheme(.dark)
        }
    }
}
