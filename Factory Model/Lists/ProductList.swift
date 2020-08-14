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
            for: factory,
            predicate: Product.factoryPredicate(for: factory)
        ) {
            CreateOrphanButton<Product>(systemName: Product.plusButtonIcon)
        } dashboard: {
            dashboard
        } editor: { (product: Product) in
            ProductView(product)
        }
        
    }
    
    @ViewBuilder
    private var dashboard: some View {
        Section(
            header: Text("TBD Total"),
            footer: Text("Go to Base to create New Product")
        ) {
            Group {
                NavigationLink(
                    destination: Text("TBD")
                ) {
                    ListRow(
                        title: "TBD Производство и продажи",
                        subtitle: "TBD Общие выручка и затраты, средние цены продаж, маржа",
                        detail: "TBD тут ли это показывать???",
                        icon: "cart"
                    )
                }
                
                NavigationLink(
                    destination: Text("TBD")
                ) {
                    ListRow(
                        title: "TBD Агрегированные данные по группам (Product Type)",
                        subtitle: "TBD Выручка и затраты, средние цены продаж, маржа",
                        detail: "TBD тут ли это показывать???",
                        icon: "cart"
                    )
                }
            }
            .font(.subheadline)
        }
    }
}
