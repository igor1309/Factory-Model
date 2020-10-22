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
            
            Section {
                AmountPicker(systemName: "building.2", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $product.initialInventory)
                
                LabelWithDetail("building.2.fill", "Closing Inventory", product.closingInventory(in: period).formattedGrouped)
                    //  MARK: - FINISH THIS COLOR CODE: RED IF NEGATIVE
                    .foregroundColor(product.closingInventory(in: period) > 0 ? .secondary : .systemRed)
            }
         
            Section(
                // header: Text("Production")
            ) {
                Group {
                    AmountPicker(systemName: "square", title: "Production Qty", navigationTitle: "Qty", scale: .large, amount: $product.productionQty)
                        .foregroundColor(product.productionQty <= 0 ? .systemRed : .accentColor)
                    
                    PeriodPicker(period: $product.period)
                }
            }

            Section(
                // header: Text("Sales")
            ) {
                LabelWithDetail("creditcard", "Sales Qty", product.salesQty(in: period).formattedGrouped)
                    //  MARK: - FINISH THIS COLOR CODE: GREEN IF > 0
                    .foregroundColor(product.salesQty(in: period) > 0 ? .systemGreen : .systemRed)

                NavigationLink(
                    destination: SalesList(for: product, in: period)
                ) {
                    Label("Sales List", systemImage: "creditcard")
                        .foregroundColor(.accentColor)
                }
                
            }
            
            
            Group {
                CostSection(cost: product.unit(in: period).cost)
                CostSection(cost: product.perKilo(in: period).cost, showBarChart: false)
                CostSection(cost: product.produced(in: period).cost, showBarChart: false)
                CostSection(cost: product.sold(in: period).cost, showBarChart: false)
            }
            
            Group {
                
                ProductionOutputSection(for: product, in: period)
                
                CostSection(cost: product.produced(in: period).cost)
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
                CostSection(cost: product.sold(in: period).cost)
                
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
