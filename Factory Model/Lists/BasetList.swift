//
//  BaseList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct BaseList: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            for: factory,
            predicate: Base.factoryPredicate(for: factory)
        ) {
            CreateChildButton(systemName: "bag.badge.plus", childType: Base.self, parent: factory, keyPath: \Factory.bases_)
        } dashboard: {
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
    }
}

