//
//  IngredientList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct IngredientList: View {
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest private var ingredients: FetchedResults<Ingredient>
//    @FetchRequest private var recipes: FetchedResults<Recipe>

    @ObservedObject var base: Base
    
    let period: Period
    
    init(for base: Base, in period: Period) {
        self.base = base
        self.period = period
        
        let predicate = NSPredicate(
            format: "ANY %K.base == %@", #keyPath(Ingredient.recipes_), base
        )
        _ingredients = Ingredient.defaultFetchRequest(with: predicate)
        
//        let recipePredicate = NSPredicate(
//            format: "ANY %K == %@", #keyPath(Base.recipes_), base
//        )
//        _recipes = Recipe.defaultFetchRequest(with: recipePredicate)
    }
    
    
    var body: some View {
        EntityListWithDashboard(
            for: base,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Recipe.ingredient), base
            ),
            in: period,
            keyPathParentToChildren: \Base.recipes_
        ) {
            GenericListSection(
                fetchRequest: _ingredients,
                in: period
            ) { ingredient in
                IngredientView(ingredient, in: period)
            }
            
            GenericListSection(
                fetchRequest: _ingredients,
                in: period
            ) { ingredient in
                IngredientView(ingredient, in: period)
            }
            
            
            Section(header: Text("Total")) {
                LabelWithDetail("puzzlepiece", "Ingredient Cost", base.ingredientsExVAT(in: period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }

        } editor: { (ingredient: Ingredient) in
            IngredientView(ingredient, in: period)
        }

    }
        var old: some View {
        List {
            
            if !ingredients.isEmpty {
                EntityRow(ingredients.first!, in: period)
            }
            
            GenericListSection(
                fetchRequest: _ingredients,
                in: period
            ) { ingredient in
                IngredientView(ingredient, in: period)
            }
            
            GenericListSection(
                fetchRequest: _ingredients,
                in: period
            ) { ingredient in
                IngredientView(ingredient, in: period)
            }
            
            
            Section(header: Text("Total")) {
                LabelWithDetail("puzzlepiece", "Ingredient Cost", base.ingredientsExVAT(in: period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Ingredient"),
                footer: Text("Sorted by Ingredient Qty")
            ) {
                ForEach(ingredients, id: \.objectID) { ingredient in
                    NavigationLink(
                        destination: IngredientView(ingredient, in: period)
                    ) {
                        EntityRow(ingredient, in: period)
                    }
                }
                .onDelete(perform: removeIngredient)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
//        .navigationBarItems(trailing: CreateOrphanButton<Ingredient>())
//        .navigationBarItems(trailing: CreateChildButton(systemName: "plus.circle", childType: Ingredient.self, parent: base, keyPath: \Base.recipes_.ingredient))
        //  MARK: - FINISH THIS USE THIS COFE FOR INGREDIENTS LIST
        //        .navigationBarItems(trailing: CreateChildButton(systemName: "plus.circle", childType: Recipe.self, parent: base, keyPath: \Base.recipes_))
    }
    
    private func removeIngredient(at offsets: IndexSet) {
        for index in offsets {
            let ingredientf = ingredients[index]
            moc.delete(ingredientf)
        }
        moc.saveContext()
    }
}

//struct IngredientList_Previews: PreviewProvider {
//    static let context = PersistenceManager(containerName: "DataModel").context
//    static let factory = Factory.createFactory1(in: context)
//    static let period: Period = .month()
//    
//    static var previews: some View {
//        NavigationView {
//            IngredientList(for: factory, in: period)
//                .preferredColorScheme(.dark)
//                .environment(\.managedObjectContext, context)
//        }
//    }
//}
