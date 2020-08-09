//
//  BaseView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Base"),
                footer: Text("Tap link to edit Base Product.")
            ) {
                NavigationLink(
                    destination: BaseEditor(base)
                ) {
                    Text("\(base.title), \(base.weightNetto.formattedGrouped)")
                }
                .foregroundColor(.accentColor)
                
                ValidationMessage(base)
            }
            
            //  parent check
            if base.factory == nil {
                Section(
                    header: Text("Factory")
                ) {
                    EntityPicker(selection: $base.factory, icon: "building.2")
                        .foregroundColor(.systemRed)
                }
            }

            Section(
                header: Text("Cost"),
                footer: Text("Cost, ex VAT")
            ) {
                Group {
                    NavigationLink(
                        destination: ListWithDashboard(
                            for: base,
                            predicate: NSPredicate(format: "%K == %@", #keyPath(Recipe.base), base)
                        ) {
                            CreateChildButton(systemName: "rectangle.badge.plus", childType: Recipe.self, parent: base, keyPath: \Base.recipes_)
                        } dashboard: {
                            
                        } editor: { (recipe: Recipe) in
                            RecipeView(recipe)
                        }
                    ) {
                        LabelWithDetail("puzzlepiece", "Ingredients Cost, ex VAT", base.ingredientsExVAT.formattedGrouped)
                    }

                    NavigationLink(
                        destination: Text("TBD: Labor Cost incl taxes")
                    ) {
                        LabelWithDetail("person.2", "Labor Cost", "TBD")
                    }

                    NavigationLink(
                        destination: UtilityList(for: base)
                    ) {
                        LabelWithDetail(Utility.icon, "Utility Cost, ex VAT", base.utilitiesExVAT.formattedGrouped)
                    }
                                        
                    LabelWithDetail("dollarsign.square", "Unit Cost of Base Product", base.ingredientsExVAT.formattedGrouped)
                        .foregroundColor(.primary)
                        .padding(.trailing)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }

            if !base.productList.isEmpty {
                Section(
                    header: Text("Used in")
                ) {
                    NavigationLink(
                        destination: Text("TBD: List of Products using base product '\(base.title)'")
                    ) {
                        Text(base.productList)
//                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
            }
            
            Section(
                header: Text("Sales")
            ) {
                Group {
                    LabelWithDetail("square", "Total Sales Qty TBD: WHAT UNIT USED???", base.salesQty.formattedGrouped)

                    LabelWithDetail(Sales.icon, "Revenue, ex VAT", base.revenueExVAT.formattedGrouped)
                    LabelWithDetail(Sales.icon, "Revenue, with VAT", base.revenueWithVAT.formattedGrouped)
                        .foregroundColor(.secondary)
                    
                    LabelWithDetail("dollarsign.circle", "Average Price, ex VAT", base.avgPriceExVAT.formattedGrouped)
                    LabelWithDetail("square", "Margin", "TBD")
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Production"),
                footer: Text("Base Products Production Quantity depends on Products Production.")
            ) {
                Group {

                    if base.closingInventory < 0 {
                        Text("Negative Closing Inventory - check Production and Sales Qty!")
                            .foregroundColor(.systemRed)
                    }
                    
                    LabelWithDetail("wrench.and.screwdriver", "Production Qty", "TBD")
                        .foregroundColor(.primary)
                    
                    LabelWithDetail("square", "TBD Production Volume - unit???", "TBD")
                        .foregroundColor(.systemRed)

                    LabelWithDetail("dollarsign.square", "Total Production Cost", "TBD")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            

            
            Section(
                header: Text("Inventory")
            ) {
                Group {
                    AmountPicker(systemName: "building.2", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $base.initialInventory)
                    
                    LabelWithDetail("building.2", "Closing Inventory", base.closingInventory.formattedGrouped)
                        .foregroundColor(base.closingInventory < 0 ? .systemRed : .secondary)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: CreateChildButton(systemName: "rectangle.badge.plus", childType: Recipe.self, parent: base, keyPath: \Base.recipes_))
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceManager(containerName: "DataModel")
        let context = persistence.context
        
        let entity = Base(context: context)
        entity.makeSketch()
        
        context.saveContext()
        
        return Group {
//            let request = Base.defaultNSFetchRequest(with: nil)
            //            if let fetch = try? context.fetch(request), let first = fetch.first {
            if let fetch = Base.fetch(in: context, configurationBlock: {_ in }), let first = fetch.first {
//                 Text("entity fetched \(first)")
                BaseView(first)
                    .environment(\.managedObjectContext, context)
            } else {
                Text("error fetching entity")
            }
        }
    }
}
