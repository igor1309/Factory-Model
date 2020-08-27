//
//  BaseView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Base Detail")
            ) {
                NavigationLink(
                    destination: BaseEditor(base)
                ) {
                    Text("\(base.title), \(base.weightNetto.formattedGrouped)")
                }
                .foregroundColor(.accentColor)
                
                ErrorMessage(base)
            }
            
            if !base.products.isEmpty {
                GenericListSection(
                    header: "Used in Products",
                    type: Product.self,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Product.base), base)
                ) { product in
                    ProductView(product)
                }
            }
            
            //  parent check
            if base.factory == nil {
                EntityPickerSection(selection: $base.factory)
            }
            
            ProductionOutputSection(for: base)
            
            ProductData(base) {
                ListWithDashboard(
                    for: base,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Recipe.base), base)
                ) {
                    CreateChildButton(systemName: "rectangle.badge.plus", childType: Recipe.self, parent: base, keyPath: \Base.recipes_)
                } dashboard: {
                    
                } editor: { (recipe: Recipe) in
                    RecipeEditor(recipe)
                }
            } employeeDestination: {
                Text("TBD: Labor Cost incl taxes")
            } equipmentDestination: {
                Text("TBD: Depreciation")
            } utilityDestination: {
                UtilityList(for: base)
            }
            
            Section(
                header: Text("Inventory")
            ) {
                Group {
                    AmountPicker(systemName: "building.2", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $base.initialInventory)
                    
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: CreateChildButton(systemName: "rectangle.badge.plus", childType: Recipe.self, parent: base, keyPath: \Base.recipes_))
    }
}
