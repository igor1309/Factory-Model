//
//  ProductView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductView: View {
    @Environment(\.managedObjectContext) var moc
    
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
                        destination: ProductEditor(product)
                    ) {
                        Text(product.title)
                    }
                }
                .foregroundColor(product.isValid ? .accentColor : .systemRed)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Production")
            ) {
                Group {
                    AmountPicker(systemName: "bag", title: "Production Qty", navigationTitle: "Qty", scale: .large, amount: $product.productionQty)
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
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.title)
        .onDisappear {
            moc.saveContext()
        }
    }
}
