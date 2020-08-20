//
//  BaseEditorOLD.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct BaseEditorOLD: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var base: Base
    
    init(_ base: Base) {
        self.base = base
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(Recipe.base), base
        )
        _recipes = Recipe.defaultFetchRequest(with: predicate)
    }
    
    @FetchRequest var recipes: FetchedResults<Recipe>
    
    var body: some View {
        List {
            NameGroupCodeNoteEditorSection(base)
            
            Section(
                header: Text("Unit")
            ) {
                ParentUnitPicker(base)
                    .foregroundColor(.accentColor)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Weight Netto")
            ) {
                AmountPicker(systemName: "scalemass", title: "Weight Netto", navigationTitle: "Weight", scale: .small, amount: $base.weightNetto)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(base.weightNetto > 0 ? .accentColor : .systemRed)
                    .font(.subheadline)
            }
            
            ErrorMessage(base)
            
            Section(
                header: Text("Ingredients"),
                footer: Text(!recipes.isEmpty ? "Tap on Recipe Name or Quantity to change." : "No recipes")
            ) {
                if !recipes.isEmpty {
                    ForEach(recipes, id: \.objectID) { recipe in
                        RecipeRow(recipe)
                    }
                }
                
                CreateChildButton(
                    title: "Add Ingredient",
                    childType: Recipe.self,
                    parent: base,
                    keyPath: \Base.recipes_)
                    .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(
            trailing: HStack {
//                CreateChildButton(
//                    systemName: "rectangle.badge.plus",
//                    childType: Recipe.self,
//                    parent: base,
//                    keyPath: \Base.recipes_)
                Button("Save") {
                    moc.saveContext()
                    presentation.wrappedValue.dismiss()
                }
            }
        )
    }
}
