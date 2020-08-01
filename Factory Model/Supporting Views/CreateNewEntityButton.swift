//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 02.08.2020.
//

import SwiftUI

struct CreateNewEntityButton: View {
    @Environment(\.managedObjectContext) var context
    
    private enum Modal { case product, sales, ingredient }
    @State private var modal: Modal = .product
    @State private var showSheet = false
    
    @State private var showActionSheet = false
    
    var body: some View {
        Button {
            showActionSheet = true
        } label: {
            Image(systemName: "ellipsis.circle")
                .padding([.leading, .vertical])
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Create new".uppercased()),
                message: Text("Select what do you want to create:"),
                buttons: [
                    .default(Text("Product")) {
                        modal = .product
                        showSheet = true
                    },
                    .default(Text("Sales")) {
                        modal = .sales
                        showSheet = true
                    },
                    .default(Text("Ingredient")) {
                        modal = .ingredient
                        showSheet = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showSheet) {
            switch modal {
                case .product:
                    NewEntityCreator(isPresented: $showSheet) { (product: Product) in
                        ProductEditorCore(product)
                    }
                    .environment(\.managedObjectContext, context)
                    
                case .sales:
                    NewEntityCreator(isPresented: $showSheet) { (sales: Sales) in
                        SalesEditorCore(sales)
                    }
                    .environment(\.managedObjectContext, context)
                    
                case .ingredient:
                    NewEntityCreator(isPresented: $showSheet) { (ingredient: Ingredient) in
                        IngredientEditorCore(ingredient)
                    }
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}
