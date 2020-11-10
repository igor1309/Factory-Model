//
//  SalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct SalesList: View {
    @ObservedObject var product: Product
    
    init(for product: Product) {
        self.product = product
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(Sales.product), product)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            for: product,
            predicate: predicate
        ) {
            CreateChildButton(
                childType: Sales.self,
                parent: product,
                keyPathToParent: \Sales.product
            )
        } dashboard: {
            ListRow(
                title: "TBD: Продажи по продукту",
                subtitle: "TBD: Деньги (выручка и маржа, маржинальность), средние цены, объемы и штуки",
                detail: "TBD: По Product и по Product Base(?)",
                icon: "creditcard"
            )
        } editor: { (sales: Sales) in
            SalesEditor(sales)
        }
    }
}

struct SalesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SalesList(for: Product.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
        }
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
