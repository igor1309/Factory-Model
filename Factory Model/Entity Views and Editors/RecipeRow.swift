//
//  RecipeRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
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
