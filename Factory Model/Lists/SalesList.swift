//
//  SalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct SalesList: View {
    @EnvironmentObject var settings: Settings
    
    let product: Product?
    let factory: Factory?
    
    init(for product: Product) {
        self.product = product
        self.factory = nil
        self.predicate = NSPredicate(format: "%K == %@", #keyPath(Sales.product), product)
    }
    
    init(for factory: Factory) {
        self.product = nil
        self.factory = factory
        self.predicate = NSPredicate(format: "%K == %@", Sales.factoryPath, factory)
    }
    
    private let predicate: NSPredicate
    
    @FetchRequest(
        entity: Sales.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
            NSSortDescriptor(keyPath: \Sales.priceExVAT, ascending: true)
        ],
        predicate: Sales.orphanPredicate
    )
    private var orphans: FetchedResults<Sales>
    
    var body: some View {
        ListWithDashboard(childType: Sales.self, predicate: predicate, plusButton: plusButton, dashboard: dashboard)
    }
    
    @ViewBuilder
    private func plusButton() -> some View {
        if let product = product {
            CreateChildButton(parent: product, keyPathToParent: \Sales.product)
        } else if let _ = factory {
            CreateNewEntityBarButton<Sales>()
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        if let product = product {
            Section(header: Text(product.name)) {
                ListRow(
                    title: "TBD: Продажи по продукту",
                    subtitle: "TBD: Деньги (выручка и маржа, маржинальность), средние цены, объемы и штуки",
                    detail: "TBD: По Product и по Product Base(?)",
                    icon: "creditcard"
                )
            }
        } else if let factory = factory {
            Section(
                header: Text("Total"),
                footer: Text("To edit Sales go to Product.")
            ) {
                LabelWithDetail("creditcard.fill", "Revenue, ex VAT", factory.revenueExVAT(in: settings.period).formattedGrouped)
                    .foregroundColor(.systemGreen)
                    .font(.subheadline)
                
                ListRow(
                    title: "TBD: Общие Продажи",
                    subtitle: "TBD: Деньги (выручка и маржа, маржинальность) и объемы",
                    detail: "TBD: ",
                    icon: "creditcard"
                )
                
                ListRow(
                    title: "TBD: Продажи по покупателям",
                    subtitle: "TBD: Деньги (выручка и маржа, маржинальность) и объемы",
                    detail: "TBD: По Product и по Product",
                    icon: "creditcard"
                )
                
                ListRow(
                    title: "TBD: Продажи по продуктам",
                    subtitle: "TBD: Деньги (выручка и маржа, маржинальность), средние цены, объемы и штуки",
                    detail: "TBD: По Product и по Product Base",
                    icon: "creditcard"
                )
            }
        } else {
            EmptyView()
        }
        
        if !orphans.isEmpty {
            GenericListSection(header: "Sales and Orphans", fetchRequest: _orphans)
                .foregroundColor(.systemRed)
        }
    }
}

struct SalesList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SalesList(for: Product.example)
            }
            .previewLayout(.fixed(width: 350, height: 400))
            
            NavigationView {
                SalesList(for: Factory.example)
            }
            .previewLayout(.fixed(width: 350, height: 700))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
