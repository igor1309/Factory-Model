//
//  BaseEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct BaseEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let baseToEdit: Base?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        baseToEdit = nil
        _factory = State(initialValue: nil)

        title = "New Base"
        
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(Recipe.base), baseToEdit
        )
        _recipes = Recipe.defaultFetchRequest(with: predicate)
    }

    init(base: Base) {
        _isPresented = .constant(true)
        baseToEdit = base
        _factory = State(initialValue: base.factory)

        title = "Edit Base"
        
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(Recipe.base), base
        )
        _recipes = Recipe.defaultFetchRequest(with: predicate)
    }
    
    @FetchRequest var recipes: FetchedResults<Recipe>
    
    @State private var factory: Factory?
    @State private var name: String
    @State private var unitString_: String
    @State private var code: String
    @State private var group: String
    @State private var note: String
    @State private var initialInventory: Double
    @State private var weightNetto: Double
    
    var body: some View {
        List {
            NameGroupCodeNoteStringEditorSection(name: $name, group: $group, code: $code, note: $note)
            
            Section(
                header: Text("Unit")
            ) {
                ParentUnitStringPicker(unitString: $unitString_)
                    .foregroundColor(.accentColor)
            }
            
            Section(
                header: Text("Weight Netto")
            ) {
                AmountPicker(systemName: "scalemass", title: "Weight Netto", navigationTitle: "Weight", scale: .small, amount: $weightNetto)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(weightNetto > 0 ? .accentColor : .systemRed)
            }
            
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
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let base: Base
                    if let baseToEdit = baseToEdit {
                        base = baseToEdit
                    } else {
                        base = Base(context: context)
                    }
                    
                    base.factory = factory
                    base.name = name
                    base.unitString_ = unitString_
                    base.code = code
                    base.code = code
                    base.group = group
                    base.note = note
                    base.initialInventory = initialInventory
                    base.weightNetto = weightNetto
                    
                    context.saveContext()
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(factory == nil || name.isEmpty || unitString_.isEmpty || weightNetto == 0)
            }
        }
    }
}
