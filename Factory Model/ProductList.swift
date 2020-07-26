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
        _products = FetchRequest(
            entity: Product.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Product.group_, ascending: true),
                NSSortDescriptor(keyPath: \Product.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "%K = %@", #keyPath(Product.base.factory), factory
            )
        )
        _allProducts = FetchRequest(
            entity: Product.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Product.group_, ascending: true),
                NSSortDescriptor(keyPath: \Product.name_, ascending: true)
            ]
//            ,
//            predicate: NSPredicate(
//                format: "%K = %@", #keyPath(Product.base.factory), factory
//            )
        )
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
            
            Section(
                header: Text("FIX: ALL Products").foregroundColor(.systemRed)
            ) {
                ForEach(allProducts, id: \.objectID) { product in
                    NavigationLink(
                        destination: ProductView(product: product, factory: factory)
                    ) {
                        ListRow(product)
                    }
                }
            }
            
            Section(
                header: Text("Products")
            ) {
                ListRow(
                    title: "SAMPLE: Название продукта, например, 'Хинкали, 12 шт'",
                    subtitle: "Базовый продукт (base) и упаковка (packaging)",
                    detail: "Объем производства (production), продажи (sales)",
                    icon: "bag.circle"
                )
                ForEach(products, id: \.objectID) { product in
                    NavigationLink(
                        destination: ProductView(product: product, factory: factory)
                    ) {
                        ListRow(product)
                    }
                }
                .onDelete(perform: removeProduct)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Products")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let product = Product(context: moc)
            product.name = " New Product"
//            factory.addToProducts_(product)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeProduct(at offsets: IndexSet) {
        for index in offsets {
            let product = products[index]
            moc.delete(product)
        }
        moc.saveContext()
    }
    
}
