//
//  ContentView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        TestingCoreDataModel()
        FactoryList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

fileprivate struct TestingCoreDataModel: View {
    var body: some View {
        NavigationView {
            List {
                CreateOrphanButton<Recipe>()
                GenericListSection(
                    type: Recipe.self,
                    predicate: nil
                ) { (recipe: Recipe) in
                    List {
                        RecipeEditorCore(recipe)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .listStyle(InsetGroupedListStyle())
//            .navigationBarItems(trailing: CreateOrphanButton<Recipe>())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
