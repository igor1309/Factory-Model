//
//  BaseEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct RecipeRow/*<T: Managed>*/: View {
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var entity: Recipe//T
    //    let keyPath: ReferenceWritableKeyPath<>
    
    init(_ entity: Recipe/*T*/) {
        self.entity = entity
    }
    
    @State private var showDeleteAction = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                EntityPicker(selection: $entity.ingredient, icon: Ingredient.icon)
                    .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                AmountPicker(navigationTitle: "Qty", scale: .small, amount: $entity.qty)
                    .buttonStyle(PlainButtonStyle())
                
                ChildUnitPicker(entity)
                
            }
            .foregroundColor(.accentColor)
            .font(.subheadline)
            
            //            RecipeUnitPicker(entity)
            
            ErrorMessage(entity)
                .font(.caption)
        }
        .contextMenu {
            Button {
                showDeleteAction = true
            } label: {
                Image(systemName: "trash.circle")
                Text("Delete")
            }
        }
        .actionSheet(isPresented: $showDeleteAction) {
            ActionSheet(
                title: Text("Delete?".uppercased()),
                message: Text("Do you really want to delete '\(entity.title)'?\nThis cannot be undone."),
                buttons: [
                    .destructive(Text("Yes, delete")) { delete(entity) },
                    .cancel()
                ]
            )
        }
    }
    
    private func delete(_ item: Recipe) {
        withAnimation {
            context.delete(item)
            context.saveContext()
        }
    }
}

struct BaseEditor: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) var presentation
    
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
            Section(
                header: Text("Base")
            ) {
                Group {
                    HStack {
                        ZStack {
                            Text("Group").hidden()
                            Text("Name")
                        }
                            .foregroundColor(.tertiary)
                        TextField("Name", text: $base.name)
                    }
                    
                    if base.baseGroups.isEmpty {
                        HStack {
                            Text("Group")
                                .foregroundColor(.tertiary)
                            TextField("Group", text: $base.group)
                                .foregroundColor(.accentColor)
                        }
                    } else {
                        PickerWithTextField(selection: $base.group, name: "Group", values: base.baseGroups)
                    }
                    
                    HStack {
                        ZStack {
                            Text("Group").hidden()
                            Text("Code")
                        }
                            .foregroundColor(.tertiary)
                        TextField("Code", text: $base.code)
                    }
                    HStack {
                        ZStack {
                            Text("Group").hidden()
                            Text("Note")
                        }
                            .foregroundColor(.tertiary)
                        TextField("Note", text: $base.note)
                    }
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
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
