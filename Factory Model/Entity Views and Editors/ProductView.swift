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
    
    init(_ product: Product) {
        self.product = product
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(Sales.product), product
        )
        _sales = Sales.defaultFetchRequest(with: predicate)
    }
    
    @FetchRequest var sales: FetchedResults<Sales>
    
    var body: some View {
        List {
            Section(
                header: Text("Product Details"),
                footer: Text(product.summary)
            ) {
                Group {
                    NavigationLink(
                        destination: ProductEditorOLD(product)
                    ) {
                        Text(product.title)
                    }
                }
                .foregroundColor(product.isValid ? .accentColor : .systemRed)
                .font(.subheadline)
            }
            
            LabelWithDetail("baseQtyInBaseUnit", "\(product.baseQtyInBaseUnit)")
            LabelWithDetail("baseQty", "\(product.baseQty)")
            LabelWithDetail("coefficientToParentUnit", "\(product.coefficientToParentUnit)")
                .foregroundColor(.red)
            
            Section(
                header: Text("Production")
            ) {
                Group {
                    AmountPicker(systemName: "square", title: "Production Qty", navigationTitle: "Qty", scale: .large, amount: $product.productionQty)
                        .foregroundColor(product.productionQty <= 0 ? .systemRed : .accentColor)
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Sales")
            ) {
                Group {
                    Group {
                        LabelWithDetail("square", "Total Sales Product Qty", product.salesQty.formattedGrouped)
                        
                        LabelWithDetail("dollarsign.circle", "Average Price, ex VAT", product.avgPriceExVAT.formattedGrouped)
                        
                        LabelWithDetail(Sales.icon, "Sales Total, ex VAT", product.revenueExVAT.formattedGrouped)
                    }
                    .foregroundColor(.primary)
                    
                    Group {
                        AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .percent, amount: $product.vat)
                        
                        LabelWithDetail(Sales.icon, "Sales Total, with VAT", product.revenueWithVAT.formattedGrouped)
                    }
                    .foregroundColor(.secondary)
                    
                    NavigationLink(
                        destination: SalesList(for: product)
                    ) {
                        LabelWithDetail("creditcard", "Sales List", "")
                    }
                    .foregroundColor(.accentColor)
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Inventory")
            ) {
                Group {
                    LabelWithDetail("square", "TBD:Inventory", "TBD")
                        .foregroundColor(.red)
                }
                .font(.subheadline)
            }
            
            
            Section(header: Text("Sales")) {
                Text("TBD: MOVE SALES TO PRODUCT!!")
                    .foregroundColor(.systemRed)
                
                Group {
                    LabelWithDetail("square", "Sales Qty", "base.totalSalesQty")
                    
                    VStack(spacing: 4) {
                        LabelWithDetail("dollarsign.circle", "Avg price, ex VAT", "base.avgPriceExVAT")
                        
                        LabelWithDetail("dollarsign.circle", "Avg price, incl VAT", "base.avgPriceWithVAT")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                    
                    LabelWithDetail("cart", "Sales, ex VAT", "base.revenueExVAT")
                    
                    LabelWithDetail("wrench.and.screwdriver", "COGS", "base.cogs")
                    
                    LabelWithDetail("rectangle.rightthird.inset.fill", "Margin****", "base.margin")
                        .foregroundColor(.systemOrange)
                    
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.title)
        .navigationBarItems(
            trailing: Button("Save") {
                moc.saveContext()
                presentation.wrappedValue.dismiss()
            }
        )
    }
}
