//
//  IngredientList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct IngredientList: View {
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var base: Base
    
    init(for base: Base) {
        self.base = base
        
        predicate = NSPredicate(
            format: "ANY %K.base == %@", #keyPath(Ingredient.recipes_), base
        )
        _ingredients = Ingredient.defaultFetchRequest(with: predicate)
        
        //        let recipePredicate = NSPredicate(
        //            format: "ANY %K == %@", #keyPath(Base.recipes_), base
        //        )
        //        _recipes = Recipe.defaultFetchRequest(with: recipePredicate)
    }
    
    @FetchRequest private var ingredients: FetchedResults<Ingredient>
    //    @FetchRequest private var recipes: FetchedResults<Recipe>
    
    private let predicate: NSPredicate
    
    var body: some View {
        EntityListWithDashboard(
            for: base,
            predicate: nil,
            //  MARK: - FINISH THIS
            //predicate: NSPredicate(
            //    format: "%K == %@", #keyPath(Recipe.ingredient), base
            //),
            keyPathParentToChildren: \Base.recipes_
        ) {
            GenericListSection(fetchRequest: _ingredients) { ingredient in
                IngredientView(ingredient)
            }
            
            GenericListSection(fetchRequest: _ingredients) { ingredient in
                IngredientView(ingredient)
            }
            
            
            Section(header: Text("Total")) {
                LabelWithDetail("puzzlepiece", "Ingredient Cost", base.ingredientsExVAT(in: settings.period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
        } editor: { (ingredient: Ingredient) in
            IngredientView(ingredient)
        }
        
    }
    var old: some View {
        List {
            
            if !ingredients.isEmpty {
                EntityRow(ingredients.first!)
            }
            
            GenericListSection(
                fetchRequest: _ingredients
            ) { ingredient in
                IngredientView(ingredient)
            }
            
            GenericListSection(fetchRequest: _ingredients) { ingredient in
                IngredientView(ingredient)
            }
            
            
            Section(header: Text("Total")) {
                LabelWithDetail("puzzlepiece", "Ingredient Cost", base.ingredientsExVAT(in: settings.period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Ingredient"),
                footer: Text("Sorted by Ingredient Qty")
            ) {
                ForEach(ingredients, id: \.objectID) { ingredient in
                    NavigationLink(
                        destination: IngredientView(ingredient)
                    ) {
                        EntityRow(ingredient)
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
            context.delete(ingredientf)
        }
        context.saveContext()
    }
}

struct IngredientList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientList(for: Base.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
