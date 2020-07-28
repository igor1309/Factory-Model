//
//  ProductList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest var products: FetchedResults<Product>
    @FetchRequest var allProducts: FetchedResults<Product>
    
    //    @ObservedObject
    var factory: Factory
    
    init(for factory: Factory){
        self.factory = factory
        
        let predicate = NSPredicate(
            format: "%K == %@", #keyPath(Product.base.factory), factory
        )
        _products = Product.defaultFetchRequest(with: predicate)
        _allProducts = Product.defaultFetchRequest()
    }
    
    var body: some View {
        List {
            Text("""
                TBD:
                - How to select Base Product to create Product here?
                - Fix Fetch Requests
                """)
                .foregroundColor(.systemRed)
                .font(.footnote)
            ListRow(
                title: "SAMPLE: Название продукта, например, 'Хинкали, 12 шт'",
                subtitle: "Базовый продукт (base) и упаковка (packaging)",
                detail: "Объем производства (production), продажи (sales)",
                icon: "bag.circle"
            )

            Section(
                header: Text("Total"),
                footer: Text("Go to Base to create New Product")
            ) {
                Group {
                    NavigationLink(
                        destination: Text("TBD")
                    ) {
                        ListRow(
                            title: "Производство и продажи",
                            subtitle: "Общие выручка и затраты, средние цены продаж, маржа",
                            detail: "тут ли это показывать???",
                            icon: "cart"
                        )
                    }
                    
                    NavigationLink(
                        destination: Text("TBD")
                    ) {
                        ListRow(
                            title: "Агрегированные данные по группам (Product Type)",
                            subtitle: "Выручка и затраты, средние цены продаж, маржа",
                            detail: "тут ли это показывать???",
                            icon: "cart"
                        )
                    }
                }
                .font(.subheadline)
            }
            
            GenericListSection(title: "ALL Products", fetchRequest: _allProducts) { product in
                ProductView(product: product, factory: factory)
            }
            
            GenericListSection(title: "Products", fetchRequest: _products) { product in
                ProductView(product: product, factory: factory)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Products")
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarItems(trailing: CreateOrphanButton<Product>())
        .navigationBarItems(trailing: PlusButton(type: Product.self))
    }
    
    private func removeProduct(at offsets: IndexSet) {
        for index in offsets {
            let product = products[index]
            moc.delete(product)
        }
        moc.saveContext()
    }
}
