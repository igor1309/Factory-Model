//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 02.08.2020.
//

import SwiftUI
import CoreData

struct CreateNewEntityButton: View {
    @Environment(\.managedObjectContext) var context
    
    private enum Modal: String { case product, sales, recipe }
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
                    .default(Text("Recipe")) {
                        modal = .recipe
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
                    //  MARK: - FINISH THIS NSClassFromString
                    //  NewEntityCreator(isPresented: $showSheet) { (sales: className) in
                    //  NewEntityCreator(isPresented: $showSheet) { (sales: typeFromString("Sales")) in
                    NewEntityCreator(isPresented: $showSheet) { (sales: Sales) in
                        SalesEditorCore(sales)
                    }
                    .environment(\.managedObjectContext, context)
                    
                case .recipe:
                    NewEntityCreator(isPresented: $showSheet) { (recipe: Recipe) in
                        RecipeEditorCore(recipe)
                    }
                    .environment(\.managedObjectContext, context)
            }
        }
    }
    
    //  MARK: - see FOR TESTING! in init() of class PersistenceManager
    //  https://stackoverflow.com/a/35395441/11793043
    //  https://stackoverflow.com/a/49328906/11793043
    //  https://stackoverflow.com/a/31147194/11793043
    //    var type: NSManagedObject.Type {
    //        NSClassFromString(modal.rawValue.capitalized) as! NSManagedObject.Type
    //    }
    //    func typeFromString(_ string: String) -> NSManagedObject.Type {
    //        NSClassFromString(string) as! NSManagedObject.Type
    //    }
}
