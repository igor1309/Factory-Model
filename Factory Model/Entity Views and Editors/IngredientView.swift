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
    
    init(_ ingredient: Ingredient) {
        self.ingredient = ingredient
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
                footer: Text("Total for the Ingredient used in production.")
            ) {
                Group {
                    LabelWithDetail("wrench.and.screwdriver", "Production Qty", ingredient.productionQty.formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Total Cost, ex VAT", ingredient.totalCostExVat.formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Total Cost, with VAT", ingredient.totalCostWithVat.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            GenericListSection(
                header: "Used in Base Products",
                type: Base.self,
                predicate: NSPredicate(format: "ANY %K.ingredient == %@", #keyPath(Base.recipes_), ingredient)
            ) { (base: Base) in
                BaseEditor(base)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(ingredient.name)
    }
}
