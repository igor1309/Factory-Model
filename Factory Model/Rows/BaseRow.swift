//
//  BaseRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI

struct BaseRow: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        
        let baseProductList = ListWithDashboard(
            title: "Base Products",
            parent: factory,
            path: "bases_",
            keyPath: \Base.factory!,
            predicate: Base.factoryPredicate(for: factory),
            useSmallerFont: true
        ) {
            Text("TBD: Ingredients")
                .foregroundColor(.systemRed)
            
            ListRow(
                title: "Общий объем производства",
                subtitle: "все продукты имеют вес нетто => общий вес",
                detail: "плюс в штуках для того, что считатся в штуках и общий вес того что по весу",
                icon: "scalemass"
            )
            
            ListRow(
                title: "Производственные затраты",
                subtitle: "Сырье и материалы, работа, энергия, амортизация оборудования и др.",
                detail: "monthly",
                icon: "dollarsign.circle"
            )
        } editor: { (base: Base) in
            BaseView(base)
        }
        
        NavigationLink(
            destination: baseProductList
        ) {
            ListRow(
                title: "Base Products",
                subtitle: ".................",
                detail: "TBD: Base products with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)",
                icon: "bag.circle"
            )
            .foregroundColor(.systemTeal)
        }
    }
}
