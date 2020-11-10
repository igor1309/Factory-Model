//
//  AllIngredientList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI
import CoreData

struct AllIngredientList: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    /// to update list (fetch) by publishing context saved event
    /// https://stackoverflow.com/a/58777603/11793043
    @State private var refreshing = false
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    var body: some View {
        ListWithDashboard(
            childType: Ingredient.self,
            for: factory,
            predicate: Ingredient.factoryPredicate(for: factory)
        ) {
            CreateOrphanButton<Ingredient>()
        } dashboard: {
            Section(
                /// refreshing UI if context was saved
                header: Text("Used in Production" + (refreshing ? "" : ""))
            ) {
                Group {
                    LabelWithDetail("squareshape.split.3x3", "No of Ingredients", factory.ingredients.count.formattedGrouped)
                    LabelWithDetail("dollarsign.circle", "Total Cost ex VAT", factory.produced(in: settings.period).cost.ingredient.valueStr)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
        /// observing context saving
        .onReceive(didSave) { _ in
            refreshing.toggle()
        }
    }
}

struct AllIngredientList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllIngredientList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
