//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationView {
            List {
                
                Section(
                    header: Text("Temporary here")
                        .foregroundColor(.systemRed)
                ) {
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Ingredient.self,
                                    predicate: nil
                                ) { (ingredient: Ingredient) in
                                    IngredientView(ingredient)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Text("Ingredients")
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Recipe.self,
                                    predicate: nil
                                ) { (recipe: Recipe) in
                                    List {
                                        //  RecipeRow(recipe)
                                        RecipeEditorCore(recipe)
                                    }
                                    .listStyle(InsetGroupedListStyle())
                                    .navigationBarTitleDisplayMode(.inline)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Text("Recipes")
                    }
                    
                    NavigationLink(
                        destination:
                            List {
                                GenericListSection(
                                    type: Base.self,
                                    predicate: nil
                                ) { (base: Base) in
                                    BaseEditor(base)
                                }
                            }
                            .listStyle(InsetGroupedListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Text("Bases")
                    }
                }
                
                GenericListSection(
                    type: Factory.self,
                    predicate: nil,
                    useSmallerFont: false
                ) { factory in
                    FactoryView(factory)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Factories")
            .navigationBarItems(trailing: MenuCreateNewOrSample())
        }
    }
    
}
