//
//  BaseEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct IngredientRow/*<T: Managed>*/: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var entity: Ingredient//T
    //    let keyPath: ReferenceWritableKeyPath<>
    
    init(_ entity: Ingredient) {
        self.entity = entity
    }
    
    @State private var showDeleteAction = false
    
    var body: some View {
        HStack {
            EntityPicker(selection: $entity.feedstock)
                .buttonStyle(PlainButtonStyle())
            Spacer()
            AmountPicker(navigationTitle: "Qty", scale: .small, amount: $entity.qty)
                .buttonStyle(PlainButtonStyle())
        }
        .foregroundColor(.accentColor)
        .font(.subheadline)
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
    
    private func delete(_ item: Ingredient) {
        withAnimation {
            context.delete(item)
            context.saveContext()
        }
    }
}

struct BaseEditor: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var base: Base
    
    init(_ base: Base) {
        self.base = base
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(Ingredient.base), base
        )
        _ingredients = Ingredient.defaultFetchRequest(with: predicate)
    }
    
    @FetchRequest var ingredients: FetchedResults<Ingredient>
    
    var body: some View {
        List {
            Section(header: Text("Base")) {
                Group {
                    TextField("Name", text: $base.name)
                    
                    if base.baseGroups.isEmpty {
                        HStack {
                            Text("Group")
                                .foregroundColor(.secondary)
                            TextField("Group", text: $base.group)
                                .foregroundColor(.accentColor)
                        }
                    } else {
                        PickerWithTextField(selection: $base.group, name: "Group", values: base.baseGroups)
                    }
                    
                    TextField("Code", text: $base.code)
                    TextField("Note", text: $base.note)
                    
                    AmountPicker(systemName: "scalemass", title: "Weight Netto", navigationTitle: "Weight", scale: .small, amount: $base.weightNetto)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Ingredients"),
                footer: Text("Tap on Ingredient Name or Quantity to change.")
            ) {
                ForEach(ingredients, id: \.objectID) { ingredient in
                    IngredientRow(ingredient)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: CreateChildButton(systemName: "rectangle.badge.plus", childType: Ingredient.self, parent: base, keyPath: \Base.ingredients_))
    }
}
