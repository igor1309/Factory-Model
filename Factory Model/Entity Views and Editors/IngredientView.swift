//
//  IngredientView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct IngredientView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var ingredient: Ingredient
    
    let period: Period
    
    init(_ ingredient: Ingredient, in period: Period) {
        self.ingredient = ingredient
        self.period = period
    }
    
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
                    ListRow(ingredient)
                }
            }
            
            ErrorMessage(ingredient)
            
            Section(
                header: Text("Usage"),
                footer: Text("Total for the Ingredient used in Production.")
            ) {
                Group {
                    LabelWithDetail("wrench.and.screwdriver", "Production Qty", ingredient.productionQty(in: period).formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Cost, ex VAT", ingredient.totalCostExVat(in: period).formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Cost, with VAT", ingredient.totalCostWithVat(in: period).formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            GenericListSection(
                header: "Used in Base Products",
                type: Base.self,
                predicate: NSPredicate(format: "ANY %K.ingredient == %@", #keyPath(Base.recipes_), ingredient),
                in: period
            ) { (base: Base) in
                BaseEditor(base, in: period)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(ingredient.name)
    }
}
