//
//  BaseView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.managedObjectContext) var moc
    
    var base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Base")
            ) {
                NavigationLink(
                    destination: BaseEditor(base)
                ) {
                    Text("\(base.title), \(base.weightNetto.formattedGrouped)")
                }
                .foregroundColor(.accentColor)
            }
            
            GenericListSection(
                type: Ingredient.self,
                predicate: NSPredicate(
                    format: "%K == %@", #keyPath(Ingredient.base), base
                )
            ) { ingredient in
                IngredientView(ingredient: ingredient)
            }
            
            LabelWithDetail("puzzlepiece.fill", "Total Ingredient Cost", base.costExVAT.formattedGrouped)
                .font(.subheadline)
            
            Section(
                header: Text("Base")
            ) {
                Group {
                    if base.closingInventory < 0 {
                        Text("Negative Closing Inventory - check Production and Sales Qty!")
                            .foregroundColor(.systemRed)
                    }
                    
                    LabelWithDetail("MARK: CHANGE IN PACKAGING AND PRODUCTION!!! Production Qty", "base.baseQty.formattedGrouped")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(header: Text("Cost")) {
                Group {
                    LabelWithDetail("Production Cost", base.costExVAT.formattedGrouped)
                    LabelWithDetail("Total Production Cost", base.totalCostExVAT.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Sales")) {
                Text("TBD: MOVE SALES TO PRODUCT!!")
                    .foregroundColor(.systemRed)
                
                Group {
                    LabelWithDetail("bag", "Sales Qty", base.totalSalesQty.formattedGrouped)
                    
                    VStack(spacing: 4) {
                        LabelWithDetail("dollarsign.circle", "Avg price, ex VAT", base.avgPriceExVAT.formattedGroupedWith1Decimal)
                        
                        LabelWithDetail("dollarsign.circle", "Avg price, incl VAT", base.avgPriceWithVAT.formattedGroupedWith1Decimal)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    
                    LabelWithDetail("cart", "Sales, ex VAT", base.revenueExVAT.formattedGrouped)
                    
                    LabelWithDetail("wrench.and.screwdriver", "COGS", base.cogs.formattedGrouped)
                    
                    LabelWithDetail("rectangle.rightthird.inset.fill", "Margin****", base.margin.formattedGrouped)
                        .foregroundColor(.systemOrange)
                    
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Inventory")) {
                Group {
                    LabelWithDetail("building.2", "Initial Inventory", base.initialInventory.formattedGrouped)
                    
                    LabelWithDetail("building.2", "Closing Inventory", base.closingInventory.formattedGrouped)
                        .foregroundColor(base.closingInventory < 0 ? .systemRed : .primary)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: PlusButton(childType: Ingredient.self, parent: base, keyPath: \Base.ingredients_))
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceManager(containerName: "DataModel")
        let context = persistence.viewContext
        
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
