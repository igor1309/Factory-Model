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
            VStack(alignment: .leading, spacing: 2) {
                LabelWithDetail("title", product.title)
                LabelWithDetail("subtitle", product.subtitle)
                LabelWithDetail("detail", product.detail ?? "")
            }
            .foregroundColor(.tertiary)
            .font(.footnote)
            
            Section(
                header: Text("Product Details")
            ) {
                Group {
                    Group {
                        NavigationLink(
                            destination: ProductEditor(product: product)
                        ) {
                            Text(product.summary)
                        }
                        
                    }
                    .foregroundColor(.accentColor)
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Base Product")
            ) {
                Group {
                    ///  MARK: если крэш будет здесь из-за optional unwrapping — значит product был где-то создан неправильно, без привязки к фабрике
                    //  MARK: не лучше ли в BasePicker вместо 'factory: Factory' сделать 'factory: Factory?'
                    BasePicker(base: $product.base, factory: product.base!.factory!)
                    
                    Stepper(value: $product.baseQty) {
                        Text("Base Qty \(product.baseQty.formattedGrouped)")
                            .font(.subheadline)
                    }
                    
                    Group {
                        LabelWithDetail("scalemass", "Вес продукта", product.weightNetto.formattedGrouped)
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                }
            }
            
            Section(
                header: Text("Packaging")
            ) {
                Group {
                    ///  MARK: если крэш будет здесь из-за optional unwrapping — значит product был где-то создан неправильно, без привязки к фабрике
                    //  MARK: не лучше ли в BasePicker вместо 'factory: Factory' сделать 'factory: Factory?'
                    PackagingPicker(packaging: $product.packaging, product: product, factory: product.base!.factory!)
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Production")
            ) {
                Group {
                    LabelWithDetailView("bag", "Production Qty", AmountPicker(navigationTitle: "Select Qty", scale: .medium, amount: $product.productionQty))
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Sales")
            ) {
                Group {
                    AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .extraSmall, amount: $product.vat)
                    
                    NavigationLink(
                        destination: SalesList(for: product)
                    ) {
                        LabelWithDetail("creditcard", "Sales Total, ex VAT", product.revenueExVAT.formattedGrouped)
                            .font(.subheadline)
                    }
                    .foregroundColor(.accentColor)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.title)
    }
}
