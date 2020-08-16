//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {
    @Environment(\.managedObjectContext) private var context
    
    @State private var showModal = false
    
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
                        Label("Ingredients", systemImage: Ingredient.icon)
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
                        Label("Recipes", systemImage: Recipe.icon)
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
                        Label("Bases", systemImage: Base.icon)
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
            .navigationBarItems(
                leading: MenuCreateNewOrSample(),
                trailing: modalButton()
            )
        }
    }
    private func modalButton() -> some View {
        Button {
            showModal = true
        } label: {
            Image(systemName: "plus.circle")
        }
        .sheet(isPresented: $showModal) {
            TestingCoreDataModel()
                .environment(\.managedObjectContext, context)
        }
    }
}
