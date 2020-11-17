//
//  IngredientView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct IngredientView: View {
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var ingredient: Ingredient
    
    init(_ ingredient: Ingredient) {
        self.ingredient = ingredient
        self.predicate = NSPredicate(format: "ANY %K.ingredient == %@", #keyPath(Base.recipes_), ingredient)
    }
    
    private let predicate: NSPredicate
    
    var unitHeader: some View {
        let text: String = {
            if let unitString_ = ingredient.unitString_ {
                return "Unit (\(unitString_))"
            } else {
                return "Unit"
            }
        }()
        
        return Text(text)
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Ingredient Detail")
            ) {
                NavigationLink(
                    destination: IngredientEditor(ingredient)
                ) {
                    ListRow(ingredient, period: settings.period)
                }
            }
            
            ErrorMessage(ingredient)
            
            Section(
                header: Text("Usage"),
                footer: Text("Total for the Ingredient used in Production.")
            ) {
                Group {
                    LabelWithDetail("wrench.and.screwdriver", "Production Qty", ingredient.productionQty(in: settings.period).formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Cost, ex VAT", ingredient.totalCostExVat(in: settings.period).formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Cost, with VAT", ingredient.totalCostWithVat(in: settings.period).formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            GenericListSection(header: "Used in Base Products", type: Base.self, predicate: predicate) 
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(ingredient.name)
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IngredientView(Ingredient.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
        .previewLayout(.fixed(width: 350, height: 600))
    }
}
