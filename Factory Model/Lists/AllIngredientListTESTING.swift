//
//  AllIngredientListTESTING.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AllIngredientListTESTING: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    @State private var ingredients: [Something]?
    //    { didSet { print(ingredients as Any) }}
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
            Text("FINISH THIS")
            //  MARK: FINISH THIS!!!
            if let ingredients = ingredients {
                Section(
                    header: Text("Ingredients")
                ) {
                    ForEach(ingredients) { ingredient in
                        ListRow(ingredient)
                    }
                }
            }
        }
        .onAppear(perform: fetchIngredients)
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Ingredient")
    }
    
    func fetchIngredients() {
        //        Factory.fetchIngredientsTotalsGrouped(context: context) {
        //        factory.fetchIngredientsTotalsGrouped { results in
//        Factory.fetchIngredientsTotalsGrouped(context: moc) { results in
//            ingredients = results
//        }
    }
}
