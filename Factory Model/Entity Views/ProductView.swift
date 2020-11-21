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
    
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var product: Product
    
    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Product Detail")
            ) {
                NavigationLink(
                    destination: ProductEditor(product)
                ) {
                    ListRow(product, period: settings.period)
                }
            }
            
            ErrorMessage(product)

            /// `Qty`
            Group {
                /// `Inventory`
                Section {
                    AmountPicker(systemName: "building.2", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $product.initialInventory)
                }
                
                /// `Production`
                Section {
                    AmountPicker(systemName: "square", title: "Production Qty", navigationTitle: "Qty", scale: .large, amount: $product.productionQty)
                        .foregroundColor(product.productionQty <= 0 ? .systemRed : .accentColor)
                    
                    PeriodPicker(period: $product.period)
                }
                
                /// `Sales`
                Section {
                    LabelWithDetail("creditcard", "Sales Qty", product.salesQty(in: settings.period).formattedGrouped)
                        .foregroundColor(product.salesQty(in: settings.period) > 0 ? .systemGreen : .systemRed)
                    
                    NavigationLink(destination: SalesList(for: product)) {
                        Label("Sales List", systemImage: "creditcard")
                            .foregroundColor(.accentColor)
                    }
                }
                
                /// `Inventory`
                LabelWithDetail("building.2.fill", "Closing Inventory", product.closingInventory(in: settings.period).formattedGrouped)
                    .foregroundColor(product.closingInventory(in: settings.period) > 0 ? .secondary : .systemRed)
            }
            
            Group {
                ProductionOutputSection(for: product)
                
                CostSection<EmptyView>(product.unit(in: settings.period).cost)
                CostSection<EmptyView>(product.perKilo(in: settings.period).cost, showBarChart: false)

                CostSection<EmptyView>(product.produced(in: settings.period).cost, showBarChart: false)
                CostSection<EmptyView>(product.produced(in: settings.period).cost)
                
                CostSection<EmptyView>(product.sold(in: settings.period).cost, showBarChart: false)
                CostSection<EmptyView>(product.sold(in: settings.period).cost)
            }
            
            Group {
                
                ProductDataCostSection(product) {
                    Text("TBD: Ingredient cost")
                } employeeDestination: {
                    Text("TBD: Labor Cost incl taxes")
                } equipmentDestination: {
                    Text("TBD: Depreciation")
                } utilityDestination: {
                    Text("TBD: Utility")
                }
                
                PriceCostMarginSection(
                    priceCostMargin: PCM(
                        price: product.perKilo(in: settings.period).price,
                        // cost: product.cost(in: settings.period)
                        //cost: product.made(in: settings.period).perUnit.cost
                        cost: product.perKilo(in: settings.period).cost.fullCost
                    ),
                    kind: .perKiloExVAT
                )

                ProductDataSections(product)
            }
            
            Group {
                Section(header: Text("Inventory")) {
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
        .navigationTitle(product.title(in: settings.period))
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductView(Product.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 1200))
    }
}
