//
//  BaseView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var base: Base
    
    init(_ base: Base) {
        self.base = base
        
        basePredicate = NSPredicate(format: "%K == %@", #keyPath(Product.base), base)
        recipePredicate = NSPredicate(format: "%K == %@", #keyPath(Recipe.base), base)
    }
    
    private let basePredicate: NSPredicate
    private let recipePredicate: NSPredicate
    
    var body: some View {
        List {
            Section(
                header: Text("Base Detail")
            ) {
                NavigationLink(
                    destination: BaseEditor(base)
                ) {
                    Text("\(base.title(in: settings.period)), \(base.weightNetto.formattedGrouped)")
                }
                .foregroundColor(.accentColor)
                
                ErrorMessage(base)
            }
            
            if !base.products.isEmpty {
                GenericListSection(
                    header: "Used in Products",
                    type: Product.self,
                    predicate: basePredicate
                ) { product in
                    ProductView(product)
                }
            }
            
            //  parent check
            if base.factory == nil {
                EntityPickerSection(selection: $base.factory, period: settings.period)
            }
            
            Group {
                ProductionOutputSection(for: base)
                
                CostSection(base.unit(in: settings.period).cost)
                CostSection(base.perKilo(in: settings.period).cost, showBarChart: false)
                
                CostSection(base.produced(in: settings.period).cost, showBarChart: false)
                CostSection(base.produced(in: settings.period).cost)
                
                CostSection(base.sold(in: settings.period).cost, showBarChart: false)
                CostSection(base.sold(in: settings.period).cost)
            }
            
            Group {
                
                ProductDataCostSection(base) {
                    ListWithDashboard(
                        for: base,
                        predicate: recipePredicate
                    ) {
                        CreateChildButton(
                            childType: Recipe.self,
                            parent: base,
                            keyPath: \Base.recipes_
                        )
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
                
                PriceCostMarginSection(
                    priceCostMargin: PCM(
                        price: base.perKilo(in: settings.period).price,
                        // cost: base.cost(in: settings.period)
                        //cost: base.made(in: settings.period).perUnit.cost
                        cost: base.perKilo(in: settings.period).cost.fullCost
                    ),
                    kind: .perKiloExVAT
                )
                
                ProductDataSections(base)
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
//        .navigationBarItems(trailing: CreateChildButton(childType: Recipe.self, parent: base, keyPath: \Base.recipes_))
        .toolbar {
            CreateChildButton(childType: Recipe.self, parent: base, keyPath: \Base.recipes_)
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BaseView(Base.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
