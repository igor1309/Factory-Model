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
    
    let period: Period
    
    init(_ entity: Recipe/*T*/, in period: Period) {
        self.entity = entity
        self.period = period
    }
    
    @State private var showDeleteAction = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                EntityPicker(selection: $entity.ingredient, icon: Ingredient.icon, period: period)
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
                message: Text("Do you really want to delete '\(entity.title(in: period))'?\nThis cannot be undone."),
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


struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                RecipeRow(Recipe.example, in: .month())
            }
        }
        .environment(\.colorScheme, .dark)
    }
}
