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
    
    let period: Period
    
    init(_ base: Base, in period: Period) {
        self.base = base
        self.period = period
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Base Detail")
            ) {
                NavigationLink(
                    destination: BaseEditor(base, in: period)
                ) {
                    Text("\(base.title(in: period)), \(base.weightNetto.formattedGrouped)")
                }
                .foregroundColor(.accentColor)
                
                ErrorMessage(base)
            }
            
            if !base.products.isEmpty {
                GenericListSection(
                    header: "Used in Products",
                    type: Product.self,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Product.base), base),
                    in: period
                ) { product in
                    ProductView(product, in: period)
                }
            }
            
            //  parent check
            if base.factory == nil {
                EntityPickerSection(selection: $base.factory, period: period)
            }
            
            ProductionOutputSection(for: base, in: period)
            
            CostSection(cost: base.unit(in: period).cost)
            CostSection(cost: base.perKilo(in: period).cost, showBarChart: false)
            CostSection(cost: base.produced(in: period).cost, showBarChart: false)
            CostSection(cost: base.sold(in: period).cost, showBarChart: false)

            ProductDataSections(base, in: period) {
                ListWithDashboard(
                    for: base,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Recipe.base), base),
                    in: period
                ) {
                    CreateChildButton(systemName: "rectangle.badge.plus", childType: Recipe.self, parent: base, keyPath: \Base.recipes_)
                } dashboard: {
                    
                } editor: { (recipe: Recipe) in
                    RecipeEditor(recipe, in: period)
                }
            } employeeDestination: {
                Text("TBD: Labor Cost incl taxes")
            } equipmentDestination: {
                Text("TBD: Depreciation")
            } utilityDestination: {
                UtilityList(for: base, in: period)
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
