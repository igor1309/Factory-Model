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
            //  MARK: - FINISH THIS FUGURE OUT HOW TO CREATE ENTITY HERE
            //  CreateOrphanButton creates new Ingredient but it's not fetched in orphans section!!!
            //CreateOrphanButton<Ingredient>()
            EmptyView()
            /* CreateChildButton(
             systemName: "plus.square",
             childType: Ingredient.self,
             parent: factory,
             keyPath: \Factory.ingredients_
             ) */
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
    static let context = PersistenceManager(containerName: "DataModel").context
    static let factory = Factory.createFactory1(in: context)
    static let period: Period = .month()
    
    static var previews: some View {
        NavigationView {
            AllIngredientList(for: factory, in: period)
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, context)
        }
    }
}
