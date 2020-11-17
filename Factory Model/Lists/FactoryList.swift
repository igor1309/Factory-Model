//
//  FactoryList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData

struct FactoryList: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        List {
            GenericListSection(type: Factory.self, predicate: nil, smallFont: false)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Factories")
        .navigationBarItems(trailing: CreateEntityPickerButton(factory: nil, isTabItem: true))
    }
}


struct FactoryList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FactoryList()
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
