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
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                EntityPicker(selection: $entity.feedstock, icon: Feedstock.icon)
                    .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                AmountPicker(navigationTitle: "Qty", scale: .small, amount: $entity.qty)
                    .buttonStyle(PlainButtonStyle())
                
                UnitPicker(unit_: $entity.unitSymbol_)
                    .buttonStyle(PlainButtonStyle())
                //            MassVolumeUnitSubPicker(unitSymbol_: $entity.unitSymbol_)
            }
            .foregroundColor(.accentColor)
            .font(.subheadline)
            
            if !entity.isValid {
                Text(entity.validationMessage)
                    .foregroundColor(.systemRed)
                    .font(.caption2)
            }
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
            Section(
                header: Text("Base")
            ) {
                Group {
                    HStack {
                        Text("Name")
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
                        Text("Code")
                            .foregroundColor(.tertiary)
                        TextField("Code", text: $base.code)
                    }
                    HStack {
                        Text("Note")
                            .foregroundColor(.tertiary)
                        TextField("Note", text: $base.note)
                    }
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Weight, Unit")
            ) {
                HStack {
                    AmountPicker(systemName: "scalemass", title: "Weight Netto", navigationTitle: "Weight", scale: .small, amount: $base.weightNetto)
                        .foregroundColor(base.weightNetto > 0 ? .accentColor : .systemRed)
                        .buttonStyle(PlainButtonStyle())
                    
                    UnitPicker(unit_: $base.unitSymbol_)
                        .foregroundColor(base.unitSymbol_ == nil ? .systemRed : .accentColor)
                        .buttonStyle(PlainButtonStyle())
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            if !base.isValid {
                Text(base.validationMessage)
                    .foregroundColor(base.isValid ? .systemGreen : .systemRed)
            }
            
            Section(
                header: Text("Ingredients"),
                footer: Text(!ingredients.isEmpty ? "Tap on Ingredient Name or Quantity to change." : "No ingredients")
            ) {
                if !ingredients.isEmpty {
                    ForEach(ingredients, id: \.objectID) { ingredient in
                        IngredientRow(ingredient)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: CreateChildButton(systemName: "rectangle.badge.plus", childType: Ingredient.self, parent: base, keyPath: \Base.ingredients_))
    }
}
