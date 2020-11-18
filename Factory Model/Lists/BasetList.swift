//
//  BaseList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct BaseList: View {
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(for: factory, keyPathToParent: \Base.factory, dashboard: dashboard)
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
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
    }
}


struct BasetList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BaseList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
