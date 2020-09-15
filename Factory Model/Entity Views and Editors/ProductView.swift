//
//  ProductView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var product: Product
    
    let period: Period
    
    init(_ product: Product, in period: Period) {
        self.product = product
        self.period = period
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Product Detail")
            ) {
                NavigationLink(
                    destination: ProductEditor(product)
                ) {
                    ListRow(product)
                }
            }
            
            ErrorMessage(product)
            
                            AmountPicker(systemName: "building.2", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $product.initialInventory)

            CostStructureSection(cost: product.unitCost(in: period))
            
            Group {
                Section(
                    header: Text("Production")
                ) {
                    Group {
                        AmountPicker(systemName: "square", title: "Production Qty", navigationTitle: "Qty", scale: .large, amount: $product.productionQty)
                            .foregroundColor(product.productionQty <= 0 ? .systemRed : .accentColor)
                    }
                }
                
                ProductionOutputSection(for: product, in: period)
                
                CostStructureSection(cost: product.productionCost(in: period))
                
                ProductDataSections(product, in: period) {
                    Text("TBD: Ingredient cost")
                } employeeDestination: {
                    Text("TBD: Labor Cost incl taxes")
                } equipmentDestination: {
                    Text("TBD: Depreciation")
                } utilityDestination: {
                    Text("TBD: Utility")
                }
            }
            
            Group {
                Section(
                    header: Text("Sales")
                ) {
                    NavigationLink(
                        destination: SalesList(for: product, in: period)
                    ) {
                        LabelWithDetail("creditcard", "Sales List", "")
                    }
                    .foregroundColor(.accentColor)
                    
                }
                
                CostStructureSection(cost: product.salesCost(in: period))
                
                Section(
                    header: Text("Inventory")
                ) {
                    Group {
                        LabelWithDetail("square", "TBD: Initial Inventory", "TBD")
                        
                        LabelWithDetail("square", "TBD: Closing Inventory", "TBD")
                    }
                    .foregroundColor(.red)
                    .font(.subheadline)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.title(in: period))
    }
}
