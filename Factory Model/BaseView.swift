//
//  BaseView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.managedObjectContext) var moc
//    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var base: Base
    
    @FetchRequest private var products: FetchedResults<Product>
    @FetchRequest private var ingredients: FetchedResults<Ingredient>

    init(_ base: Base) {
        self.base = base
        
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(Product.base), base
        )
        _products = Product.defaultFetchRequest(with: predicate)
        
        _ingredients = FetchRequest(
            entity: Ingredient.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Ingredient.qty, ascending: true)
            ],
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Ingredient.base), base
            )
        )
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Base")
            ) {
                NavigationLink(
                    destination: BaseEditor(base)
                ) {
                    Text(base.title)
                }
            }
            
            GenericListSection(title: "Ingredients", fetchRequest: _ingredients) { ingredient in
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
        .navigationBarItems(trailing: plusButton)
    }
    
    //  MARK: - can't replace with PlusEntityButton: addToIngredients_
    private var plusButton: some View {
        Button {
            let ingredient = Ingredient(context: moc)
            ingredient.qty = 1_000
            base.addToIngredients_(ingredient)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView(Base())
    }
}
