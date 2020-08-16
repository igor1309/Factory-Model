//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 02.08.2020.
//

import SwiftUI
import CoreData

struct MenuCreateNewOrSample: View {
    @Environment(\.managedObjectContext) private var context
    
    private enum Modal: String { case product, sales, recipe }
    @State private var modal: Modal = .product
    @State private var showSheet = false
    
    @State private var showActionSheet = false
    
    var body: some View {
        
        Menu {
            Section(header: Text("Create New")) {
                Button {
                    modal = .product
                    showSheet = true
                } label: {
                    Label("Create a Product", systemImage: Product.plusButtonIcon)
                }
                
                Button {
                    modal = .sales
                    showSheet = true
                } label: {
                    Label("Create a Sale", systemImage: Sales.plusButtonIcon)
                }
                
                Button {
                    modal = .recipe
                    showSheet = true
                } label: {
                    Label("Create a Recipe", systemImage: Recipe.plusButtonIcon)
                }
            }
            
            Section(header: Text("Create New Factory")) {
                Button {
                    let entity = Factory.create(in: context)
                    entity.makeSketch()
                    entity.objectWillChange.send()
                    
                    context.saveContext()
                } label: {
                    Label("Create a Factory", systemImage: Factory.icon)
                }
            }
            
            Section(header: Text("Sample Factory")) {
                Button {
                    let _ = Factory.createFactory1(in: context)
                    context.saveContext()
                } label: {
                    Label("Сыроварня", systemImage: "plus")
                }
                
                Button {
                    let _ = Factory.createFactory2(in: context)
                    context.saveContext()
                } label: {
                    Label("Полуфабрикаты", systemImage: "plus")
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }

        
        .sheet(isPresented: $showSheet) {
            switch modal {
                case .product:
                    EntityCreator(isPresented: $showSheet) { (product: Product) in
                        ProductEditorCore(product)
                    }
                    .environment(\.managedObjectContext, context)
                    
                case .sales:
                    //  MARK: - FINISH THIS NSClassFromString
                    //  NewEntityCreator(isPresented: $showSheet) { (sales: className) in
                    //  NewEntityCreator(isPresented: $showSheet) { (sales: typeFromString("Sales")) in
                    EntityCreator(isPresented: $showSheet) { (sales: Sales) in
                        SalesEditorCore(sales)
                    }
                    .environment(\.managedObjectContext, context)
                    
                case .recipe:
                    EntityCreator(isPresented: $showSheet) { (recipe: Recipe) in
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
