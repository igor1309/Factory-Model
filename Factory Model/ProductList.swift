//
//  ProductList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory){
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            predicate: Product.factoryPredicate(for: factory)
        ) {
            Button {
                //  MARK: - FINISH THIS FIGURE OUT HOW TO CREATE PRODUCT HERE
                
            } label: {
                Image(systemName: Product.icon)
                    .padding([.leading, .vertical])
            }
        } dashboard: {
            dashboard
        } editor: { (product: Product) in
            ProductView(product)
        }
        
    }
    
    @ViewBuilder
    private var dashboard: some View {
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
    }
}
